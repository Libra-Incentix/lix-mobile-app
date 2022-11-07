import 'package:lix/models/link_model.dart';
import 'package:lix/models/project_model.dart';
import 'package:lix/models/user.dart';

class TaskModel {
  int? id;
  String? title;
  String? description;
  int? teamId;
  ProjectModel? project;
  LinkModel? link;
  User? user;
  int? totalCoinsAvailable;
  int? coinsPerAction;
  String? approvalType;
  int? numberOfSubmissionsAllowedPerPeriod;
  dynamic period;
  String? privacyType;
  String? proofType;
  String? numberOfSubmissionsAllowed;
  String? privacy;
  String? status;
  String? avatar;
  String? createdAt;
  String? updatedAt;
  String? qrCodeImage;
  TaskModel({
    this.id,
    this.title,
    this.description,
    this.teamId,
    this.project,
    this.link,
    this.user,
    this.totalCoinsAvailable,
    this.coinsPerAction,
    this.approvalType,
    this.numberOfSubmissionsAllowedPerPeriod,
    this.period,
    this.privacyType,
    this.proofType,
    this.numberOfSubmissionsAllowed,
    this.privacy,
    this.status,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.qrCodeImage,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    ProjectModel? pModel;
    LinkModel? lModel;
    User? user;
    try {
      if (json['project'] != null) {
        pModel = ProjectModel.fromJson(json['project']);
      }

      if (json['link'] != null) {
        lModel = LinkModel.fromJson(json['link']);
      }

      if (json['user'] != null) {
        user = User.fromJson(json['user']);
      }
      return TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        teamId: json['team_id'],
        project: pModel,
        link: lModel,
        user: user,
        qrCodeImage: json['task_qrcode_image'],
        totalCoinsAvailable: json['total_coins_available'],
        coinsPerAction: json['coins_per_action'],
        approvalType: json['approval_type'],
        numberOfSubmissionsAllowedPerPeriod:
            json['number_of_submissions_allowed_per_period'],
        period: json['period'],
        privacyType: json['privacy_type'],
        proofType: json['proof_type'],
        numberOfSubmissionsAllowed: json['number_of_submissions_allowed'],
        privacy: json['privacy'],
        status: json['status'],
        avatar: json['avatar'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    } on Exception catch (exception) {
      print(exception.toString());
    } catch (error) {
      print(error);
    }
    return TaskModel();
  }
}
