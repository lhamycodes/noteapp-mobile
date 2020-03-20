import 'dart:convert';
import 'package:http/http.dart';

import '../models/note.dart';
import '../models/user.dart';

import '../ui/views/app/dashboard.dart';

import '../services/note_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../services/authentication_service.dart';

import '../locator.dart';

import 'application_view_model.dart';
import 'base_model.dart';

class NoteViewModel extends BaseModel {
  final NoteService _noteService = locator<NoteService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Map _noteData = {};
  Map get noteData => _noteData;

  Future create() async {
    setBusy(true);

    var result = await _noteService.create(
      noteData: _noteData,
      endpoint: "notes",
    );

    setBusy(false);

    if (result.runtimeType == Response) {
      var body = jsonDecode(result.body);
      if (result.statusCode == 200) {
        setBusy(true);

        User user = ApplicationViewModel().user;
        user.notes.add(Note.fromJson(body['data']['note']));
        _authenticationService.loadUser(user.toJson());

        setBusy(false);

        _navigationService.navigateAndClearRoute(DashboardScreen.routeName);
      } else if (result.statusCode == 400) {
        await _dialogService.showDialog(
          title: 'Note Creation Failed',
          description: body['message'],
        );
      } else {
        await _dialogService.showDialog(
          title: 'Note Creation Failed',
          description: body['message'],
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Application error',
        description: result.toString(),
      );
    }
  }

  Future edit(String uuid) async {
    setBusy(true);

    var result = await _noteService.update(
      noteData: _noteData,
      endpoint: "notes/$uuid",
    );

    setBusy(false);

    if (result.runtimeType == Response) {
      var body = jsonDecode(result.body);
      if (result.statusCode == 200) {
        setBusy(true);

        User user = ApplicationViewModel().user;
        Note note = user.notes.firstWhere((note) => note.uuid == uuid);
        int noteIdx = user.notes.indexOf(note);
        user.notes[noteIdx] = Note.fromJson(body['data']['note']);
        _authenticationService.loadUser(user.toJson());

        setBusy(false);

        _navigationService.navigateAndClearRoute(DashboardScreen.routeName);
      } else if (result.statusCode == 400) {
        await _dialogService.showDialog(
          title: 'Note Creation Failed',
          description: body['message'],
        );
      } else {
        await _dialogService.showDialog(
          title: 'Note Creation Failed',
          description: body['message'],
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Application error',
        description: result.toString(),
      );
    }
  }

  Future delete(String uuid) async {
    setBusy(true);

    var result = await _noteService.delete(
      endpoint: "notes/$uuid",
    );

    setBusy(false);

    if (result.runtimeType == Response) {
      var body = jsonDecode(result.body);
      if (result.statusCode == 200) {
        setBusy(true);

        User user = ApplicationViewModel().user;
        Note note = user.notes.firstWhere((note) => note.uuid == uuid);
        int noteIdx = user.notes.indexOf(note);
        user.notes.removeAt(noteIdx);
        _authenticationService.loadUser(user.toJson());

        setBusy(false);

        _navigationService.navigateAndClearRoute(DashboardScreen.routeName);
      } else if (result.statusCode == 400) {
        await _dialogService.showDialog(
          title: 'Note Creation Failed',
          description: body['message'],
        );
      } else {
        await _dialogService.showDialog(
          title: 'Note Creation Failed',
          description: body['message'],
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Application error',
        description: result.toString(),
      );
    }
  }
}
