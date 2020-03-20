import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/ui/shared/ui_helpers.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../shared/app_colors.dart';
import '../../../viewmodels/application_view_model.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/app/dashboard';

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ApplicationViewModel>.withConsumer(
      viewModel: ApplicationViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => await model.onWillPop(),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "Hello, ${model.user.name.split(' ')[0]}",
                style: TextStyle(color: primaryColor),
              ),
              elevation: 3,
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                  icon: Icon(FeatherIcons.logOut),
                  onPressed: () => model.logout(),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => model.toRoute("create-note"),
              backgroundColor: primaryColor,
              tooltip: "Create note",
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (cx, i) => GestureDetector(
                  onTap: () {
                    model.toRoute("edit-note", argument: model.user.notes[i]);
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      title: Text(model.user.notes[i].title),
                      subtitle: Text(model.user.notes[i].description),
                      isThreeLine: false,
                    ),
                  ),
                ),
                itemCount: model.user.notes.length,
                separatorBuilder: (cx, _) => verticalSpace(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
