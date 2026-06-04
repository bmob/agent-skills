import UIKit

class Player: BmobObject {
    var title: String? = nil
    var name: String? = nil
    var isStudent: Bool = false
    var age: Int = 0

    static func convert(obj: BmobObject) -> Player {
        let test = Player.convertWithObject(obj)
        if let isStudent = obj.objectForKey("isStudent") {
            test.isStudent = isStudent as! Bool
        }
        if let age = obj.objectForKey("age") {
            test.age = age as! Int
        }
        return test
    }

    override func sub_saveInBackgroundWithResultBlock(_ block: BmobBooleanResultBlock!) {
        self.className = "Player"
        self.setObject(isStudent, forKey: "isStudent")
        self.setObject(age, forKey: "age")
        super.sub_saveInBackgroundWithResultBlock(block)
    }
}