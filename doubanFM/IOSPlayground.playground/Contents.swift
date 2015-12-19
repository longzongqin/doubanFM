//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//元组
var tus = (1,2,3,"longzongqin",3.3,3.123445)
println(tus.3)
//取磨
var a = 5%0.4
//三目
var b = a>1 ? a : 1
//数组
var myList = ["a","b","c","d"]
myList.append("longzongqin")
myList.insert("first", atIndex: 0)
myList.append("25")
println(myList)
for v in myList{
    println(v)
}
//字典
var myHash:Dictionary = ["name":"longzongqin","age":25,"address":"北京"]
for (k,v) in myHash{
    println("\(k):\(v)")
}

for i in 0...myHash.count{
    println(i)
}
//函数
func getPerson(#name:String,age:Int)->(name:String,age:Int){
    return (name,age);
}
var name = getPerson(name:"longzongqin", 25).name

func changeName(inout name:String)->String{
    name += "AAA"
    return name;
}
changeName(&name)
println(name)

func nameChanged((inout String)->String){
    
}
var changFun = changeName
nameChanged(changFun)

var myArr = [1,2,"nihao",3.455,true,false]
for ii in myArr{
    println(ii)
}
protocol Ni{
    func getName()
}

class Test:Ni{
    var name = "longzongqin"
    var age = 25
    func getName() {
         println(name)
    }
}

var myClass = Test()
myClass.name.isEmpty


for one in 1...9{
    for two in 1...one{
        print("\(two) * \(one) = \(one * two)")
        print(" ")
    }
    println(" ")
}














