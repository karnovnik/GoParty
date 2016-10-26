//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let stin: String.Index = str.startIndex.advancedBy(4)
str.substringFromIndex(stin)

class Tmp {
    var f_name = "dsad"
    var l_name = "czxc"
    var age = 10
    
    func toString() -> String {
        var res = ""
        let mirrored_object = Mirror(reflecting: self)
        
        for (_, attr) in mirrored_object.children.enumerate() {
            if let property_name = attr.label as String! {
                res += "\(property_name) : \(attr.value)\n"
            }
        }
        return res
    }
}

var tmp = Tmp()
print(tmp.toString())

struct User {
    var uid:String
    var name:String
    init( uid: String, name: String ) {
        self.uid = uid
        self.name = name
    }
    
}

let arr = [User( uid: "1", name: "name1"),User( uid: "2", name: "name2"),User( uid: "3", name: "name3"),User( uid: "4", name: "name4")]

let set = ["2","3"]

var result = arr.filter({set.contains($0.uid)})
print(result)


func getFakeCoordinate() -> String {
    var str = ""
    str += String( Int( arc4random_uniform( 9 ) + 1 ) )
    str += String( Int( arc4random_uniform( 9 ) + 1 ) )
    str += "."
    for _ in 1...6{
        str += String( Int( arc4random_uniform( 10 ) ) )
    }
    
    return str
}

for _ in 1...100 {
    print(getFakeCoordinate())
}



