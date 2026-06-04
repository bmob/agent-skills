Bmob.getTableSchemasWithClassName("_User") { (bmobTableSchema, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else if let schema = bmobTableSchema {
        print("\(schema.description)")
        print("表名: \(schema.className)")
        let fields = schema.fields
        for key in fields.keys {
            print("列名: \(key)")
            if let fieldStruct = fields[key] {
                let type = fieldStruct["type"] as! String
                print("列类型: \(type)")
                if type == "Pointer" {
                    print("关联关系指向的表名: \(fieldStruct["targetClass"] ?? "")")
                }
            }
        }
    }
}