import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _posts = [];

  List<Map<String, dynamic>> get posts => _posts;

  Future<void> loadPosts(String community) async {
    final query = await _firestore.collection('posts').where('community', isEqualTo: community).get();
    _posts = query.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Future<void> addPost(Map<String, dynamic> post) async {
    await _firestore.collection('posts').add(post);
    _posts.add(post);
    notifyListeners();
  }
}
