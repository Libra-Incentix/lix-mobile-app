// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class EarnWithLix extends StatefulWidget {
  final List<TaskModel> allTasks;
  Function onTap;
  Function viewAllAction;
  EarnWithLix({
    Key? key,
    required this.onTap,
    required this.allTasks,
    required this.viewAllAction,
  }) : super(key: key);

  @override
  State<EarnWithLix> createState() => _EarnWithLixState();
}

class _EarnWithLixState extends State<EarnWithLix> {
  late List<TaskModel> allTasks = widget.allTasks;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earn with LIX',
                style: textStyleBoldBlack(16),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.viewAllAction();
                },
                child: Text(
                  'View All',
                  style: textStyleViewAll(12),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            height: 166.0,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () => widget.onTap(allTasks[index]),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      allTasks[index].title ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  subtitle: Text(
                    '${allTasks[index].coinsPerAction} LIX',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ColorSelect.appThemeOrange,
                      fontFamily: 'Inter',
                    ),
                  ),
                  leading: Image(
                    image: provideImage(allTasks[index]),
                    fit: BoxFit.fitHeight,
                    height: 50,
                    width: 50,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider provideImage(TaskModel task) {
    if (task.avatar == null ||
        task.avatar!.isEmpty ||
        !task.avatar!.contains('http')) {
      return const AssetImage('assets/images/no-img.png');
    }

    return NetworkImage(task.avatar!);
  }
}
