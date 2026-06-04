let wageinfo = BmobObject(className: "wageinfo")
wageinfo.setObject(2000, forKey: "wage")

let boss = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let hr_zhang = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let hr_luo = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let cashier_xie = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")
let me = BmobUser(outDataWithClassName: "", objectId: "xxxxxx")

let hr = BmobRole(name: "HR")
let cashier = BmobRole(name: "Cashier")

let hrRelation = BmobRelation()
hrRelation.addObject(hr_zhang)
hrRelation.addObject(hr_luo)
hr.addRolesRelation(hrRelation)
hr.saveInBackground()

let cashierRelation = BmobRelation()
cashierRelation.addObject(cashier_xie)
cashier.addRolesRelation(cashierRelation)
cashier.saveInBackground()

let acl = BmobACL()
acl.setReadAccessForUser(boss)
acl.setReadAccessForUser(me)
acl.setReadAccessForRole(hr)
acl.setReadAccessForRole(cashier)

acl.setWriteAccessForUser(boss)
acl.setWriteAccessForRole(hr)

wageinfo.ACL = acl
wageinfo.saveInBackgroundWithResultBlock { (isSuccessful, error) in
    if isSuccessful {
        print("success")
    } else {
        print("error \(error?.localizedDescription ?? "")")
    }
}