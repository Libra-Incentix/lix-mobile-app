import 'package:flutter/material.dart';
import 'package:lix/models/country_model.dart';
import 'package:lix/models/country_phone_model.dart';
import 'package:lix/screens/widgets/custom_appbar.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/select_flag.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:collection/collection.dart';

class CountryPhoneSelector extends StatefulWidget {
  final List<CountryPhone> countryList;
  Function onChanged;
  CountryPhoneSelector({
    Key? key,
    required this.countryList,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CountryPhoneSelector> createState() => _CountryPhoneSelectorState();
}

class _CountryPhoneSelectorState extends State<CountryPhoneSelector> {
  late List<CountryPhone> countryList = widget.countryList;
  late List<CountryPhone> filteredCountries = widget.countryList;
  CountryPhone? selectedCountry;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          customAppBar("Select Country", context),
          const SizedBox(
            height: 6,
          ),
          Container(
            height: 46,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: inputField(
              "Search",
              searchController,
              false,
              context,
              (String fieldName, String value) {
                filteredCountryList();
              },
              TextInputType.text,
              showPrefix: true,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                return SelectFlag(
                  onTap: (String countryName) {
                    CountryPhone? c = filteredCountries.singleWhereOrNull(
                      (element) => element.name == countryName,
                    );
                    setState(() {
                      selectedCountry = c;
                    });
                  },
                  icon: filteredCountries[index].flag!,
                  text: filteredCountries[index].name!,
                  isSelected: isCountrySelected(filteredCountries[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: SubmitButton(
              onTap: () {
                Navigator.pop(context);
                if (selectedCountry != null) {
                  widget.onChanged(selectedCountry);
                }
              },
              text: "Change Country",
              disabled: false,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool isCountrySelected(CountryPhone country) {
    if (selectedCountry != null) {
      return country.id == selectedCountry!.id;
    }

    return false;
  }

  filteredCountryList() {
    List<CountryPhone> countries = List.from(countryList);
    List<CountryPhone> c = countries;
    if (searchController.text.isNotEmpty) {
      c = countries.where((element) {
        String query = searchController.text.toLowerCase();
        return element.name!.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      filteredCountries = c;
    });
  }
}
