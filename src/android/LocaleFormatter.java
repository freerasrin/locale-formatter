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
package com.rasrin.locale.formatter.plugin;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import java.text.NumberFormat;
import java.util.Locale;

public class LocaleFormatter extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        
            
            try{
                
                if (action.equals("formatCurrency")) {
                
                    if(args.length() < 3){
                        callbackContext.error("Expected 3 arguments.");
                        return false;
                    }

                    String ilocale = args.getString(0);
                    long amount = args.getLong(1);
                    boolean debug = args.getBoolean(2);
                    Locale locale = new Locale("en","US");
                    if(ilocale != null && ilocale.length() <= 5){
                        if(ilocale.indexOf('-') > 0){
                            String[] parts = ilocale.split("-");
                            locale = new Locale(parts[0],parts[1]);
                        }
                    }

                    NumberFormat formatter = NumberFormat.getCurrencyInstance(locale);
                    String moneyString = formatter.format(amount);

                    if(debug){
                        System.out.println("Called with locale: " + ilocale + " & amount: " + amount + ". Formatted string is: " + moneyString);    
                    }

                    callbackContext.success(moneyString);

                    return true;
                    
                }else{
                    callbackContext.error("Unsupported operation");
                    return false;
                }
                
            }catch(Exception ex){
                callbackContext.error("Something went wrong: " + ex.getMessage());
                return false;
            }
            
        
        
    }

}
