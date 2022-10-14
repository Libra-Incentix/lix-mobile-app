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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      body: ListView.builder(
        itemCount: allTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // first creating task link model...
              TaskLinkModel taskLinkModel =
                  TaskLinkModel(task: allTasks[index]);

              // TODO change this later...
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
            leading: allTasks[index].avatar != null
                ? Image.network(
                    apiService.imagesPath + (allTasks[index].avatar ?? ''),
                    width: 50,
                    height: 50,
                    fit: BoxFit.fitHeight)
                : const Image(
                    image: AssetImage("assets/icons/earn_2.png"),
                    fit: BoxFit.fitHeight,
                    height: 50,
                    width: 50,
                  ),
          );
        },
      ),
    );
  }
}
