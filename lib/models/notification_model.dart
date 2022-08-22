class NotificationModel {
  //simple Model class
  String title;
  bool read;
  String desc;
  String imgPath;

  NotificationModel(
      {required this.title,
      required this.desc,
      required this.read,
      required this.imgPath});
}
