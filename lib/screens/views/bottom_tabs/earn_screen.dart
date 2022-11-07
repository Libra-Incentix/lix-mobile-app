import 'package:flutter/material.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/task_link.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/earn_details_screen.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';
import 'package:loadmore/loadmore.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  late User user = locator<HelperService>().getCurrentUser()!;
  HelperService helperService = locator<HelperService>();
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  List<TaskModel> allTasks = [];
  bool loading = false;
  late ScrollController controller;
  int count = 15;

  showLoading() {
    if (!mounted) return;
    setState(() {
      loading = true;
    });
  }

  hideLoading() {
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    initialize();
    controller = ScrollController()..addListener(handleScrolling);
    super.initState();
  }

  void handleScrolling() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      print("handle scrolling end");
      setState(() {
        count += 10;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(handleScrolling);
  }

  initialize() async {
    try {
      showLoading();
      List<TaskModel> tasks = await apiService.getGlobalTasks(user);
      if (tasks.isNotEmpty && mounted) {
        setState(() {
          allTasks = tasks;
        });
      }
      hideLoading();
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(e.message),
      );
    } catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Earn",
          style: textStyleBoldBlack(16),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: controller,
              itemCount: allTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    // first creating task link model...
                    TaskLinkModel taskLinkModel = TaskLinkModel(
                      task: allTasks[index],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EarnDetailsScreen(
                          taskLink: taskLinkModel,
                          offerModel: null,
                        ),
                      ),
                    );
                  },
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
                    "${(allTasks[index].coinsPerAction)} LIX",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(210, 114, 84, 1),
                      fontFamily: 'Inter',
                    ),
                  ),
                  leading: provideImage(allTasks[index]),
                );
              },
            ),
    );
  }

  Widget provideImage(TaskModel task) {
    if (task.avatar == null ||
        task.avatar!.isEmpty ||
        !task.avatar!.contains('http')) {
      return Image.asset(
        'assets/images/no-img.png',
        height: 48,
        width: 48,
      );
    }

    return Image.network(
      task.avatar!,
      height: 48,
      width: 48,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/no-img.png',
          height: 48,
          width: 48,
        );
      },
    );
  }
}
