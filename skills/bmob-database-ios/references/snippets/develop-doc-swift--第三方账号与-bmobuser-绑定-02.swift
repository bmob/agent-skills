// 手机 QQ 账号关联到当前用户
let dic = ["access_token": _tencentOauth.accessToken, "uid": _tencentOauth.openId, "expirationDate": _tencentOauth.expirationDate]
let user = BmobUser.getCurrentUser()
user.linkedInBackgroundWithAuthorDictionary(dic, platform: BmobSNSPlatformQQ) { (isSuccessful, error) in
    print("bindResult \(isSuccessful)")
}