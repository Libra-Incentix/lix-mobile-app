import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class TaskProofDialog extends StatefulWidget {
  const TaskProofDialog({Key? key}) : super(key: key);

  @override
  State<TaskProofDialog> createState() => _TaskProofDialogState();
}

class _TaskProofDialogState extends State<TaskProofDialog> {
  TextEditingController textProofController = TextEditingController();

  @override
  void dispose() {
    textProofController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Please submit proof of task completion.',
                  style: textStyleBoldBlack(24),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              textProof(fullWidth),
              const SizedBox(
                height: 15,
              ),
              imageProof(fullWidth),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                margin: const EdgeInsets.only(
                  bottom: 16,
                ),
                child: SubmitButton(
                  onTap: () {},
                  text: 'Submit',
                  color: ColorSelect.lightBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textProof(double width) {
    // TODO change this with actual condition...
    if (true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            width: width,
            child: Text(
              'Please submit the code, that you\'ve received.',
              style: textStyleBoldBlack(14).copyWith(
                fontWeight: FontWeight.w500,
                color: ColorSelect.lightBlack.withOpacity(.8),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: TextFormField(
              controller: textProofController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  // borderSide: Border.all(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                hintText: 'Enter code...',
                hintStyle: textStyleBoldBlack(16).copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorSelect.lightBlack.withOpacity(.4),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget imageProof(double width) {
    if (true) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            width: width,
            child: Text(
              'Please submit the screenshot of the completion.',
              style: textStyleBoldBlack(14).copyWith(
                fontWeight: FontWeight.w500,
                color: ColorSelect.lightBlack.withOpacity(.8),
              ),
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            child: Container(
              height: 60,
              width: width,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Text(
                'Select image...',
                style: textStyleBoldBlack(16).copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorSelect.lightBlack.withOpacity(.4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      );
    }
    return Container();
  }
}
