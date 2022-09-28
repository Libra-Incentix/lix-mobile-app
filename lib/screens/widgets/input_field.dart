import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lix/app/color_select.dart';

Widget inputField(
  String name,
  TextEditingController controller,
  bool obsecureText,
  BuildContext context,
  Function onChanged,
  TextInputType inputType, {
  showPrefix = false,
  Function? onTap,
  int maxLength = 1000,
  bool isEnabled = true,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: TextFormField(
      enabled: isEnabled,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      controller: controller,
      keyboardType: inputType,
      obscureText: obsecureText,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      onChanged: (e) {
        onChanged(name, e);
      },
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        prefixIcon: showPrefix ? const Icon(Icons.search, size: 20) : null,
        fillColor: ColorSelect.appThemeGrey,
        labelText: name,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: ColorSelect.greyDark,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: controller.text.isEmpty
                ? ColorSelect.appThemeGrey
                : Colors.black,
            width: 0.6,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
  );
}
