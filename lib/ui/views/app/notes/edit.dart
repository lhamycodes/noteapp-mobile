import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/ui/widgets/busy_overlay.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../../shared/ui_helpers.dart';
import '../../../shared/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../../viewmodels/note_view_model.dart';

class EditNote extends StatefulWidget {
  static const routeName = '/app/notes/edit';

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isInit = false;
  Note currentNote;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      currentNote = ModalRoute.of(context).settings.arguments;
      _titleController.text = currentNote.title;
      _descController.text = currentNote.description;
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NoteViewModel>.withConsumer(
      viewModel: NoteViewModel(),
      onModelReady: (model) => {},
      builder: (context, model, child) => BusyOverlay(
        show: model.busy,
        title: "Updating",
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FeatherIcons.trash2,
                  color: Colors.red,
                ),
                onPressed: () => model.delete(currentNote.uuid),
              ),
              FlatButton.icon(
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  model.edit(currentNote.uuid);
                },
                icon: Icon(Icons.check),
                label: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textColor: primaryColor,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "NotesApp",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      " - Edit",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
                verticalSpace(15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        label: "Title",
                        hintText: "Hello World",
                        keyboardAction: TextInputAction.next,
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          model.noteData['title'] = val;
                        },
                        textController: _titleController,
                      ),
                      verticalSpace20,
                      CustomTextField(
                        label: "Description",
                        hintText: "lorem ipsum dolor sit amit .....",
                        keyboardAction: TextInputAction.done,
                        minLines: 25,
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          model.noteData['description'] = val;
                        },
                        textController: _descController,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
