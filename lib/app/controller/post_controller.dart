import 'package:dio/dio.dart';
import 'package:flight_app/app/config/env.dart';
import 'package:flight_app/models/realModel/post.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final posts = <Post>[].obs;
  // final post = Post(id: 0, title: '', image: '', description: '', likes: 0, createdAt: DateTime.now()).obs;
  final id = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  // ─── Бүх post авах ─────────────────────────────────
  Future<void> fetchPosts({int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;
      final response = await dio.get(
        '/api/posts',
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'] as List;
      posts.value = data.map((e) => Post.fromJson(e)).toList();
    } on DioException catch (e) {
      errorMessage.value =
          e.response?.data?['message'] ?? 'Failed to load posts';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Like хийх ─────────────────────────────────────
  Future<void> likePost(int id) async {
    try {
      await dio.patch('/api/posts/$id/like');
      // Local дээр шууд update
      final index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        final old = posts[index];
        posts[index] = Post(
          id: old.id,
          title: old.title,
          image: old.image,
          description: old.description,
          likes: old.likes + 1,
          createdAt: old.createdAt,
        );
      }
    } on DioException catch (e) {
      print('Like error: ${e.response?.data}');
    }
  }

  // ─── Хайлт ─────────────────────────────────────────
  Future<void> searchPost(String query) async {
    try {
      isLoading.value = true;
      final response = await dio.get(
        '/api/posts',
        queryParameters: {'search': query},
      );

      final data = response.data['data'] as List;
      posts.value = data.map((e) => Post.fromJson(e)).toList();
    } on DioException catch (e) {
      errorMessage.value = e.response?.data?['message'] ?? 'Search failed';
    } finally {
      isLoading.value = false;
    }
  }
}
