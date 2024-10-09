//
//  ScriptUtil.swift
//  Mini
//
//  Created by Austin Vesich on 10/9/24.
//

import Carbon

enum ScriptErrors: Error {
    case executionError
    
    var description: String {
        "The script failed to execute."
    }
}

func callAppleScript(_ scriptURL: URL, withMainFuncName funcName: String, andArgs args: [String] = []) throws {
    var errors: NSDictionary?
    let script = NSAppleScript(contentsOf: scriptURL, error: nil)
    let handler = NSAppleEventDescriptor(string: funcName)
    let argumentList = NSAppleEventDescriptor.init(listDescriptor: ())

    var offset = 0
    for arg in args {
        let argDescriptor = NSAppleEventDescriptor.init(string: arg)
        argumentList.insert(argDescriptor, at: 1+offset)
        offset += 1
    }

    let event = NSAppleEventDescriptor.appleEvent(withEventClass: AEEventClass(kASAppleScriptSuite), eventID: AEEventID(kASSubroutineEvent), targetDescriptor: nil, returnID: AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))
    event.setParam(handler, forKeyword: AEKeyword(keyASSubroutineName))
    event.setParam(argumentList, forKeyword: AEKeyword(keyDirectObject))
    let returnedDescriptor = script?.executeAppleEvent(event, error: &errors)
    
    if errors != nil && errors!.count > 0 {
        throw ScriptErrors.executionError
    }

}
