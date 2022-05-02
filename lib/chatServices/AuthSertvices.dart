import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handyman_provider_flutter/models/LoginResponse.dart';
import 'package:handyman_provider_flutter/models/UserData.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/DashboardScreen.dart';
import 'package:handyman_provider_flutter/screens/LoginScreen.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthServices {
  Future<void> updateUserData(UserData user) async {
    userService.updateDocument({
      'player_id': getStringAsync(PLAYERID),
      'updatedAt': Timestamp.now(),
    }, user.uid);
  }

  Future<void> signUpWithEmailPassword(context, {String? name, String? email, String? password, String? mobileNumber, String? lName, String? userName}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
    if (userCredential != null && userCredential.user != null) {
      User currentUser = userCredential.user!;

      UserData userModel = UserData();
      var displayName = name! + lName!;

      /// Create user
      userModel.uid = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.contactNumber = mobileNumber;
      userModel.firstName = name;
      userModel.lastName = lName;
      userModel.username = userName;
      userModel.displayName = displayName;
      userModel.userType = UserTypeProvider;
      userModel.createdAt = Timestamp.now().toDate().toString();
      userModel.updatedAt = Timestamp.now().toDate().toString();
      userModel.playerId = getStringAsync(PLAYERID);

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
        var request = {
          UserKeys.firstName: name,
          UserKeys.lastName: lName,
          UserKeys.userName: userName,
          UserKeys.userType: UserTypeProvider,
          UserKeys.contactNumber: mobileNumber,
          UserKeys.email: email,
          UserKeys.password: password,
          UserKeys.uid: userModel.uid,
        };

        await registerUser(request).then((res) async {
          appStore.setLoading(false);
          toast(res.message);
          await loginUser(request).then((res) async {
            if (res.data!.status.validate() != 0) {
              DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
            } else {
              toast('Please wait for admin to accept your request ');
              push(LoginScreen(), isNewTask: true);
            }
          }).catchError((e) {
            toast(e.toString());
          });
        }).catchError((e) {
          toast(e.toString());
        });

        await signInWithEmailPassword(context, email: email, password: password).then((value) {
          //
        });
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signIn(context, {String? email, String? password, LoginResponse? res}) async {
    UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
    if (userCredential != null && userCredential.user != null) {
      User currentUser = userCredential.user!;

      UserData userModel = UserData();

      /// Create user
      userModel.uid = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.contactNumber = res!.data!.contactNumber;
      userModel.firstName = res.data!.firstName;
      userModel.lastName = res.data!.lastName;
      userModel.username = res.data!.username;
      userModel.displayName = res.data!.displayName;
      userModel.countryId = res.data!.countryId;
      userModel.address = res.data!.address;
      userModel.playerId = res.data!.address;
      userModel.cityId = res.data!.cityId;
      userModel.stateId = res.data!.stateId;
      userModel.userType = UserTypeProvider;
      userModel.createdAt = Timestamp.now().toDate().toString();
      userModel.updatedAt = Timestamp.now().toDate().toString();
      userModel.playerId = getStringAsync(PLAYERID);

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
        appStore.setUId(currentUser.uid);

        await signInWithEmailPassword(context, email: email, password: password).then((value) {
          //
        });
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signInWithEmailPassword(context, {required String email, required String password}) async {
    _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      final User user = value.user!;
      UserData userModel = await userService.getUser(email: user.email);
      await updateUserData(userModel);

      setValue(UID, userModel.uid.validate());
      setValue(USER_EMAIL, userModel.email.validate());
      setValue(IS_LOGGED_IN, true);

      //Login Details to AppStore
      appStore.setUserEmail(userModel.email.validate());
      appStore.setUId(userModel.uid.validate());
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw 'Please check network connection';
      }
      throw 'Enter valid email and password';
    });
  }
}
