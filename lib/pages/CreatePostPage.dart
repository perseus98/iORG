import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final ValueChanged _onChanged = (val) => print(val);
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Create Post"),
      ),
      body: ListView(
        children: <Widget>[
          FormBuilder(
            key: _fbKey,
            // initialValue: {
            //   'date': DateTime.now(),
            // },
            autovalidate: true,
            readOnly: false,
            child: Column(
              children: <Widget>[
                FormBuilderImagePicker(
                  attribute: 'images',
                  decoration: const InputDecoration(
                    labelText: 'Pick a document:',
                  ),
                  defaultImage: NetworkImage(
                      'https://cohenwoodworking.com/wp-content/uploads/2016/09/image-placeholder-500x500.jpg'),
                  maxImages: 1,
                  iconColor: Colors.red,
                  // readOnly: true,
                  validators: [
                    FormBuilderValidators.required(),
                    (images) {
                      if (images.length <= 0) {
                        return 'Image required.';
                      }
                      return null;
                    }
                  ],
                  onChanged: _onChanged,
                ),
                SizedBox(height: 15),
                FormBuilderTextField(
                  attribute: 'name',
                  // autovalidate: true,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name:',
                  ),
                  onChanged: (val) {
                    print(val);
                    // setState(() {
                    //   _ageHasError = !_fbKey
                    //       .currentState.fields['age'].currentState
                    //       .validate();
                    // });
                  },
                  // valueTransformer: (text) {
                  //   return text == null ? null : num.tryParse(text);
                  // },
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),
                FormBuilderDateTimePicker(
                  attribute: 'date',
                  onChanged: _onChanged,
                  inputType: InputType.both,
                  decoration: const InputDecoration(
                    labelText: 'Deadline:',
                  ),
                  validator: (val) => null,
                  // locale: Locale('ru'),
                  initialTime: TimeOfDay.now(),
                  initialValue: DateTime.now(),
                  // readonly: true,
                ),
                SizedBox(height: 15),
                FormBuilderSlider(
                  attribute: 'slider',
                  decoration: const InputDecoration(
                    labelText: 'Set Priority:',
                  ),
                  onChanged: _onChanged,
                  min: 1.0,
                  max: 5.0,
                  initialValue: 3.0,
                  divisions: 5,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  displayValues: DisplayValues.current,
                ),
                SizedBox(height: 15),
                FormBuilderTextField(
                  attribute: 'details',
                  // autovalidate: true,
                  controller: _detailsController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Details',
                  ),
                  onChanged: (val) {
                    print(val);
                    // setState(() {
                    //   _ageHasError = !_fbKey
                    //       .currentState.fields['details'].currentState
                    //       .validate();
                    // });
                  },
                  // valueTransformer: (text) {
                  //   return text == null ? null : num.tryParse(text);
                  // },
                  // validators: [
                  //   FormBuilderValidators.required(),
                  //   FormBuilderValidators.,
                  // ],
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              MaterialButton(
                child: Text("Submit"),
                onPressed: () {
                  if (_fbKey.currentState.saveAndValidate()) {
                    print(_fbKey.currentState.value);
                  }
                },
              ),
              MaterialButton(
                child: Text("Reset"),
                onPressed: () {
                  _fbKey.currentState.reset();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
