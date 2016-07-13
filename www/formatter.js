/*
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


var ln = {};

/******************
 * Public Constants
 ******************/

/******************
 * Public API
 ******************/

/**
 * Delegation shim to determine by arguments if API call is v2 or v3 and delegate accordingly.
 */
ln.formatCurrency = function(locale, amount, debug, successCallback, errorCallback){
	
	// Input validation
    function throwError(errMsg){
        if(errorCallback){
            errorCallback(errMsg);
        }
        throw new Error(errMsg);
    }
	
    if(!locale || !amount || isNaN(parseFloat(amount)) || typeof(successCallback) != "function" || typeof(errorCallback) != "function"){
        throwError("Not valid arguments");
		return;
    }
	
	if(debug){
		console.log('Called with locale: ' + locale + ' amount: ' + amount);
	}
	
	cordova.exec(successCallback, errorCallback, 'LocaleFormatter', 'formatCurrency', [
        locale,
        amount,
        debug
    ]);
};

/*******************
 * Utility functions
 *******************/
ln.util = {};
ln.util.arrayContainsValue = function (a, obj) {
    var i = a.length;
    while (i--) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
};

ln.util.objectContainsKey = function (o, key) {
    for(var k in o){
        if(k === key){
            return true;
        }
    }
    return false;
};

ln.util.objectContainsValue = function (o, value) {
    for(var k in o){
        if(o[k] === value){
            return true;
        }
    }
    return false;
};

ln.util.countKeysInObject = function (o){
    var count = 0;
    for(var k in o){
        count++;
    }
    return count;
};

module.exports = ln;
