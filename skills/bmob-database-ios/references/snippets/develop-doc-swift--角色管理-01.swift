let wageinfo = BmobObject(className: "wageinfo")
wageinfo.setObject(2000, forKey: "wage")

let boss = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let hr_zhang = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let cashier_xie = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let me = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")

let acl = BmobACL()
acl.setReadAccessForUser(boss)
acl.setReadAccessForUser(hr_zhang)
acl.setReadAccessForUser(cashier_xie)
acl.setReadAccessForUser(me)

acl.setWriteAccessForUser(boss)
acl.setWriteAccessForUser(hr_zhang)

wageinfo.ACL = acl
wageinfo.saveInBackgroundWithResultBlock { (isSuccessful, error) in
    if isSuccessful {
        print("success")
    } else {
        print("error \(error?.localizedDescription ?? "")")
    }
}