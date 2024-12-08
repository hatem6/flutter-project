// lib/data/repositories/article_repository.dart
import '../../../../core/network/api_client.dart';
import '../models/article_model.dart';

class ArticleRepository {
  final ApiClient apiClient;

  ArticleRepository({required this.apiClient});

  // Fetch articles by userId
  Future<List<Article>> getArticlesByUserId(int userId) async {
    try {
      // Make a GET request to fetch articles for the given userId
      final data = await apiClient.get('/articles/user/$userId');
      
      // Convert the data to a list of Article objects
      List<dynamic> articlesData = data['articles'];
      return articlesData.map((data) => Article.fromJson(data)).toList();
    } catch (error) {
      throw Exception('Failed to load articles: $error');
    }
  }

  Future<bool> addArticle(int userId, String title, String content) async {
    try {
      final response = await apiClient.post('/article/create', {
         // Include userId in the request
        'title': title,
        'content': content,
        'userId': userId,
      });

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateArticle(int articleId, String title, String content) async {
  final response = await apiClient.put('/article/$articleId', {   
    'title': title,
    'content': content,
  });

  if (response.statusCode == 200) {
    return true; // Successfully updated
  } else {
    return false; // Failed to update
  }
}

Future<bool> deleteArticle(int articleId) async {
  final response = await apiClient.delete('/article/$articleId');

  if (response.statusCode == 200) {
    return true; // Successfully deleted
  } else {
    return false; // Failed to delete
  }
}

}
