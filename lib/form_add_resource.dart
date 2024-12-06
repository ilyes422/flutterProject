import 'package:flutter/material.dart';
import 'cocktails_page.dart';
import 'food_page.dart';

class FormAddResource extends StatelessWidget {
  final String? selectedValue;

  const FormAddResource({super.key, this.selectedValue});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Add a drink/meal';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: Text(
            appTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
      ),
      body: AddResourceForm(selectedValue: selectedValue),
    );
  }
}

class AddResourceForm extends StatefulWidget {
  final String? selectedValue;

  const AddResourceForm({super.key, this.selectedValue});

  @override
  AddResourceFormState createState() {
    return AddResourceFormState();
  }
}

class AddResourceFormState extends State<AddResourceForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedValue;
  final List<String> _options = ['Drink', 'Meal'];
  String? _name;
  String? _category;
  String? _description;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose an option',
                border: OutlineInputBorder(),
              ),
              value: _selectedValue,
              onChanged: (newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
              },
              items: _options.map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String selectedValue = _selectedValue ?? 'No value selected';
                      String name = _name ?? 'Unnamed';
                      String category = _category ?? '';
                      String description = _description ?? '';
                      if(selectedValue == "Drink"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CocktailsPage(
                              selectedValue: selectedValue ?? 'Drink',
                              name: _name ?? '',
                              category: _category ?? '',
                              description: _description ?? '',
                            ),
                          ),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodPage(
                              selectedValue: selectedValue ?? 'Meal',
                              name: _name ?? '',
                              category: _category ?? '',
                              description: _description ?? '',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
