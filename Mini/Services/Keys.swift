//
//  Keys.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

struct Keys {
    static func keyCode(for key: String) -> Int {
        Keys.codes[key] ?? 0
    }
    
    static let codes = [
        "q" : 12,
        "w" : 13,
        "e" : 14,
        "r" : 15,
        "t" : 17,
        "y" : 16,
        "u" : 32,
        "i" : 34,
        "o" : 31,
        "p" : 35,
        "{" : 33,
        "[" : 33,
        "}" : 30,
        "]" : 30,
        "|" : 42,
        "\\" : 42,
        "a" : 0,
        "s" : 1,
        "d" : 2,
        "f" : 3,
        "g" : 5,
        "h" : 4,
        "j" : 38,
        "k" : 40,
        "l" : 37,
        ":" : 41,
        ";" : 41,
        "\"" : 39,
        "z" : 6,
        "x" : 7,
        "c" : 8,
        "v" : 9,
        "b" : 11,
        "n" : 45,
        "m" : 46,
        "<" : 43,
        "," : 43,
        ">" : 47,
        "." : 47,
        "?" : 44,
        "/" : 44,
    ]
}
