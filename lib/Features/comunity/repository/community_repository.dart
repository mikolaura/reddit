import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/models/community_model.dart';
final communityRepositoryProvider = Provider((ref) {
  return  CommunityRepository(firestore: ref.watch(firestoreProvider));
});
class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore}): _firestore = firestore;
  FutureVoid createCommunity(Community community)async {
    try{
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists){
        throw 'Communty with the same already exts';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch(e){
      return left(Failer(e.message!));
    } catch(e){
      return left(Failer(e.toString()));
    }
  }
  Stream<List<Community>> getUserComminuties(String uid){
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var doc in event.docs){
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }
  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);
}