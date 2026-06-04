//查询username字段的值含有“sm”的数据
query.addWhereContains("username", "sm");

//查询username字段的值是以“sm“字开头的数据
query.whereStartsWith("username", "sm");

// 查询username字段的值是以“ile“字结尾的数据
query.whereEndsWith("username", "ile");