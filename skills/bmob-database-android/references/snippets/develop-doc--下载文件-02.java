/**
 * @param fileName 文件名(必填)
 * @param group 组名（选填）
 * @param url  完整url地址（必填）
 * 注：必须要有文件名和文件的完整url地址，group可为空
 */
public BmobFile(String fileName,String group,String url){
	this.filename = fileName;
	this.group=group;
	this.url = url;
}
