//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let age = 3
for i in 0...100 where i % 3 == 0 {
    print(i)
}

let start = str.startIndex
let end = str.index(start, offsetBy: 4)
let aChar = str[end]
let range = start...end
let subStr = str[range]
