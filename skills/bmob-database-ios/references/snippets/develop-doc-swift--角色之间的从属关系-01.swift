let mobileDep = BmobRole(name: "MobileDep")
let androidTeam = BmobRole(name: "AndroidTeam")
let iosTeam = BmobRole(name: "iOSTeam")

androidTeam.saveInBackground()
iosTeam.saveInBackground()

let relation = BmobRelation()
relation.addObject(androidTeam)
relation.addObject(iosTeam)
mobileDep.addRolesRelation(relation)

let coreCode = BmobObject(className: "Code")
let androidCode = BmobObject(className: "Code")
let iosCode = BmobObject(className: "Code")
// ......此处省略一些具体的属性设定
coreCode.saveInBackground()
androidCode.saveInBackground()
iosCode.saveInBackground()

androidCode.ACL.setReadAccessForRole(androidTeam)
androidCode.ACL.setWriteAccessForRole(androidTeam)

iosCode.ACL.setReadAccessForRole(iosTeam)
iosCode.ACL.setWriteAccessForRole(iosTeam)

coreCode.ACL.setReadAccessForRole(mobileDep)