import 'package:flutter/material.dart';
import '../data/repositories/article_repository.dart';
import '../data/models/article_model.dart';
import '../../../core/network/api_client.dart';

class ArticlesPage extends StatefulWidget {
  final int userId;

  ArticlesPage({required this.userId});

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  late Future<List<Article>> _articlesFuture;
  late ArticleRepository articleRepository;

  @override
  void initState() {
    super.initState();

    // Initialize the ApiClient and ArticleRepository
    final apiClient = ApiClient(baseUrl: 'http://localhost:3001');
    articleRepository = ArticleRepository(apiClient: apiClient);

    // Fetch articles for the given userId
    _articlesFuture = articleRepository.getArticlesByUserId(widget.userId);
  }

  // Method to delete an article
  void _deleteArticle(int articleId) async {
    final success = await articleRepository.deleteArticle(articleId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article deleted successfully')));
      setState(() {
        _articlesFuture = articleRepository.getArticlesByUserId(widget.userId); // Refresh the list
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete article')));
    }
  }

  // Method to navigate to the update page
  void _updateArticle(int articleId, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateArticlePage(
          articleId: articleId,
          title: title,
          content: content,
          articleRepository: articleRepository, // Pass the repository here
           onUpdateSuccess: () {
            // Refresh the articles list after a successful update
            setState(() {
              _articlesFuture = articleRepository.getArticlesByUserId(widget.userId);
            });
          },
        ),
      ),
    );  
  }

  void _addArticle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddArticlePage(
          userId: widget.userId, // Pass userId to AddArticlePage
          articleRepository: articleRepository,
          onAddSuccess: () {
            setState(() {
              _articlesFuture = articleRepository.getArticlesByUserId(widget.userId); // Refresh the list
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Articles'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    title: Text(article.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(article.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _updateArticle(article.id, article.title, article.content);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteArticle(article.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No articles found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addArticle,
        child: Icon(Icons.add),
      ),
    );
  }
}

class UpdateArticlePage extends StatefulWidget {
  final int articleId;
  final String title;
  final String content;
  final ArticleRepository articleRepository; // Add this line
  final Function onUpdateSuccess; 

  // Constructor expects articleRepository to be passed
  UpdateArticlePage({
    required this.articleId,
    required this.title,
    required this.content,
    required this.articleRepository,  // Ensure the repository is required
    required this.onUpdateSuccess,
  });

  @override
  _UpdateArticlePageState createState() => _UpdateArticlePageState();
}

class _UpdateArticlePageState extends State<UpdateArticlePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Article'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedTitle = _titleController.text;
                final updatedContent = _contentController.text;

                // Call the updateArticle method using the repository
                final success = await widget.articleRepository.updateArticle(
                  widget.articleId,
                  updatedTitle,
                  updatedContent,
                );

                if (success) {
                  widget.onUpdateSuccess();
                  Navigator.pop(context);  // Go back after successful update
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Article updated successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update article')),
                  );
                }
              },
              child: Text('Update Article'),
            ),
          ],
        ),
      ),
    );
  }
}


class AddArticlePage extends StatefulWidget {
  final int userId; // Accept userId
  final ArticleRepository articleRepository;
  final Function onAddSuccess;

  AddArticlePage({
    required this.userId, // Accept userId in the constructor
    required this.articleRepository,
    required this.onAddSuccess,
  });

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Article'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final content = _contentController.text;

                final success = await widget.articleRepository.addArticle(
                  widget.userId, // Pass userId here
                  title,
                  content,
                );

                if (success) {
                  widget.onAddSuccess();
                  Navigator.pop(context); // Go back after successful add
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Article added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add article')),
                  );
                }
              },
              child: Text('Add Article'),
            ),
          ],
        ),
      ),
    );
  }
}
