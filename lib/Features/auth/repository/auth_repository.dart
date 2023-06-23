import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/models/asUser_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider), auth: ref.read(authProvider), googleSignIn: ref.read(googleSignInProvider)));
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;
        CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle () async {
    try {
      final GoogleSignInAccount? googleUer = await _googleSignIn.signIn();
      final googleAuth = await googleUer?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
     
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      late UserModel user;
      if(userCredential.additionalUserInfo!.isNewUser){
      
      user = UserModel(
        name: userCredential.user!.displayName?? "No name",
         profilePic: userCredential.user!.photoURL?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
           uid: userCredential.user!.uid??"", 
           isAuthenticated: true,
            karma: 0,
             awards: []
             );
          
          await _users.doc(userCredential.user!.uid).set(user.toMap());
          } else{
            user = await getUserData(userCredential.user!.uid).first;
            print(user.toString());
          }
          return right(user);
    } on FirebaseException catch(e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }
  Stream<UserModel> getUserData(String uid) {
    // print(_users.doc(uid).snapshots().map((event) => user.fromMap(event.data() as Map<String, dynamic>).toString()));
    // return _users.where('uid', isEqualTo: uid).snapshots().map((event) => user.fromMap(event as Map<String, dynamic>));
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
