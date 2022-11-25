import 'package:app_cantina_murialdo/helpers/firebase_errors.dart';
import 'package:app_cantina_murialdo/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;

  bool get isLoggedIn => user != null;

  bool _loading = false;

  bool get loading => _loading;

  // ignore: avoid_positional_boolean_parameters
  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _fbLoading = false;

  bool get fbLoading => _fbLoading;

  // ignore: avoid_positional_boolean_parameters
  void setFbLoading(bool value){
    _fbLoading = value;
    notifyListeners();
  }

  Future<void> sigIn({User user, Function onFail, Function onSuccess}) async{
    setLoading(true);
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      await _loadCurrentUser(firebaseUser: result.user);


      onSuccess();
    }on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async{
    setFbLoading(true);
    FacebookLogin().logOut();

    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch(result.status){

      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token
        );

        final authResult = await auth.signInWithCredential(credential);

        if(authResult.user != null){
          final firebaseUser = authResult.user;

          user = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
            credit: 0.0,
          );

          user.saveData();

          user.saveToken();

          onSuccess();

        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }
    setFbLoading(false);
  }


  Future<void> editUser({@required User user, @required Function onFail, @required Function onSuccess, }) async{
    setLoading(true);
    try{
      this.user = user;
      await user.updateData();
      onSuccess();
    }catch(e){
      onFail(e);
    }
    setLoading(false);
  }

  Future<void> signUp({@required User user, @required Function onFail, @required Function onSuccess}) async{
    setLoading(true);
    try{
      final AuthResult result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      user.id = result.user.uid;

      this.user = user;

      await user.saveData();

      user.saveToken();

      onSuccess();

    }on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async{
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      user.saveToken();

      final docAdmin = await firestore.collection('admins').document(user.id).get();
      if(docAdmin.exists){
        user.admin = true;
      }


      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;

}
