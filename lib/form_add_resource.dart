import 'package:flutter/material.dart';

class FormAddResource extends StatelessWidget {
  const FormAddResource({super.key});

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
      body: const AddResourceForm(),
    );
  }
}


class AddResourceForm extends StatefulWidget {
  const AddResourceForm({super.key});

  @override
  AddResourceFormState createState() {
    return AddResourceFormState();
  }
}

class AddResourceFormState extends State<AddResourceForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedValue;
  final List<String> _options = ['Drink', 'Meal'];
  String? _category;
  String? _description;

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
                  value: value,
                  child: Text(value),
                );
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
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
