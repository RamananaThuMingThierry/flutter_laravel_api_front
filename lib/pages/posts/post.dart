import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/post.dart';
import 'package:flutter_laravel_api/pages/commentaires/commentaires.dart';
import 'package:flutter_laravel_api/pages/posts/post_form.dart';
import 'package:flutter_laravel_api/screens/login.dart';
import 'package:flutter_laravel_api/services/post_service.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';

class PostIndex extends StatefulWidget {
  const PostIndex({Key? key}) : super(key: key);

  @override
  State<PostIndex> createState() => _PostIndexState();
}

class _PostIndexState extends State<PostIndex> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool loading = true;

  // Get all Posts
  Future<void> retrievePosts() async{

    userId = await getUserId();

    ApiResponse response = await getPost();

    if(response.error == null){
      setState(() {
        _postList = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),):
        RefreshIndicator(
          onRefresh: (){
            return  retrievePosts();
          },
          child: ListView.builder(
              itemCount: _postList.length,
              itemBuilder: (BuildContext context, int index){
                Posts post = Posts.fromJson(_postList[index]);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                               child: Row(
                                 children: [
                                   Container(
                                     width: 38,
                                     height: 38,
                                     decoration: BoxDecoration(
                                       image: _postList[index]['user']['image'] != null ? DecorationImage(image: NetworkImage('${post.user!.image}')) : null,
                                       borderRadius: BorderRadius.circular(25),
                                       color: Colors.amber
                                     ),
                                   ),
                                   SizedBox(width: 10,),
                                   Text(
                                     '${_postList[index]['user']['name']}',
                                     style: TextStyle(
                                       fontWeight: FontWeight.w600,
                                       fontSize: 18,
                                     ),
                                   )
                                 ],
                               ),
                          ),
                          _postList[index]['user']['id'] == userId
                              ?
                          PopupMenuButton(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.more_vert, color: Colors.black,),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                 child: Text('Modifier'),
                                  value: "modifier",
                                ),
                                PopupMenuItem(
                                child: Text('Supprimer'),
                                value: "supprimer",
                                ),
                              ],
                              onSelected:(value){
                                    if(value == "modifier"){
                                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => PostForm(title: "Modifier post",post: post,)));
                                    }else{
                                       _handleDeletePost(post!.id ?? 0);
                                    }
                              }
                            )
                              :
                          SizedBox()
                        ],
                      ),
                      SizedBox(height: 12,),
                      post.image == null
                          ?
                            SizedBox(
                              height: 180,
                              child: Container(
                                color: Colors.blueGrey,
                                child: Center(
                                  child: Text("${post.body}", style: TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                              ),
                            )
                          :
                      Text("${post.body}"),
                      post.image != null ?
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('${post.image}'),
                                fit: BoxFit.cover
                              )
                            ),
                          )
                          :
                          SizedBox(height: post.image != null ? 0 : 10,),
                      Row(
                        children: [
                          kLikeAndComment(
                              _postList[index]['likes_count'] ?? 0,
                              _postList[index]['likes_count'] > 0
                                  ? _postList[index]['likes'].toList().isEmpty
                                    ? Icons.favorite_outline
                                    : Icons.favorite
                                  : Icons.favorite_outline,
                              _postList[index]['likes_count'] > 0
                                  ? _postList[index]['likes'].toList().isEmpty
                                      ? Colors.black
                                      : Colors.red
                                  : Colors.black38,
                              (){
                                _handlePostLikeDisLike(post!.id ?? 0);
                              }
                          ),
                          Container(
                            height: 25,
                            width: .5,
                            color: Colors.black38,
                          ),
                          kLikeAndComment(
                              post.commentairesCount ?? 0,
                              Icons.sms_outlined,
                              Colors.black54,
                              (){
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => CommentairesIndex(postId: post.id,)));
                              }
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: .5,
                        color: Colors.black26,
                      )
                    ],
                  ),
                );
              }),
        );
  }

  // post like or dislike
  void _handlePostLikeDisLike(int postId) async{
    ApiResponse response = await likeUnlikePost(postId);
    if(response.error == null){
      retrievePosts();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _handleDeletePost(int postId) async{
    ApiResponse response = await deletePost(postId);
    if(response.error == null){
      retrievePosts();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
