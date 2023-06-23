import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Features/auth/controllers/auth_controller.dart';
import 'package:reddit/Features/comunity/repository/community_repository.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';
final userCommunitiesProvider = StreamProvider((ref)  {
  final CommunityController  =ref.watch(communityControllerProvider.notifier);
  return CommunityController.getUserComminuties();
});
final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref);
});
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required ref})
      : _communityRepository = communityRepository,
        _ref = ref, super(false);
  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
        final res =  await _communityRepository.createCommunity(community)
        ;
        state = false;
        res.fold((l) => showSnakcBar(context, l.message), (r){
          showSnakcBar(context, "Community create sucsessfully");
          Routemaster.of(context).pop();
        });
  }
  Stream<List<Community>> getUserComminuties(){
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserComminuties(uid);
  }
}
