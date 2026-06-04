// 先按照年龄升序排序，年龄一样再按照更新时间降序排序
query.orderByAscending("age")
query.orderByDescending("updatedAt")