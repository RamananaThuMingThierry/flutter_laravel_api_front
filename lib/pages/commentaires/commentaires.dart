import 'package:flutter/material.dart';
import 'package:flutter_laravel_api/api/api_response.dart';
import 'package:flutter_laravel_api/models/commentaires.dart';
import 'package:flutter_laravel_api/screens/login.dart';
import 'package:flutter_laravel_api/services/commentaires_services.dart';
import 'package:flutter_laravel_api/services/user_services.dart';
import 'package:flutter_laravel_api/utils/constant.dart';

class CommentairesIndex extends StatefulWidget {
  int? postId;

  CommentairesIndex({this.postId});

  @override
  State<CommentairesIndex> createState() => _CommentairesIndexState();
}

class _CommentairesIndexState extends State<CommentairesIndex> {
  List<dynamic> _commentairesList = [];
  bool loading = true;
  int userId = 0;
  int _editCommentaireId = 0;
  TextEditingController commentairesController = TextEditingController();

  // Get Commentaires
  Future<void> _getCommentaires() async{
    //userId = await getUserId();
    ApiResponse response = await getCommentaires(widget.postId ?? 0);

    if(response.error == null){
      setState(() {
        _commentairesList = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  void initState() {
    _getCommentaires();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commentaires"),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) :
      Column(
        children: [
          Expanded(child: RefreshIndicator(
            onRefresh: (){
              return _getCommentaires();
            },
            child: ListView.builder(
                itemCount: _commentairesList.length,
                itemBuilder: (BuildContext context, int index){
                  Commentaires comments = _commentairesList[index];
                  return Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                          width: .5,
                          color: Colors.black26
                        )
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    image: comments.user!.image != null ? DecorationImage(
                                        image: NetworkImage('${comments.user!.image}'),
                                      fit: BoxFit.cover
                                    ): null,
                                     borderRadius: BorderRadius.circular(15),
                                     color: Colors.blueGrey
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text('${comments.user!.name}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                              ],
                            ),
                            comments.user!.id == userId ?
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
                                    setState(() {
                                      _editCommentaireId = comments.id ?? 0;
                                      commentairesController.text = comments.commentaires ?? '';
                                    });
                                  }else{
                                    _deleteCommentaire(comments.id ?? 0);
                                  }
                                }
                            ): SizedBox()
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text('${comments.commentaires}')
                      ],
                    ),
                  );
                }),
          )),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black26, width: .5),
              )
            ),
            child: Row(
              children: [
                Expanded(child: TextFormField(
                  decoration: inputDecoration('Commentaire'),
                  controller: commentairesController,
                )),
                IconButton(
                    onPressed: (){
                      if(commentairesController.text.isNotEmpty){
                        setState(() {
                          loading = true;
                        });
                        _editCommentaireId > 0 ? _editCommaentaires(): _createCommentaire();
                      }
                    },
                    icon: Icon(Icons.send)
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _editCommaentaires() async{
    ApiResponse response = await updateCommentaires(_editCommentaireId, commentairesController.text);
    if(response.error == null){
      _editCommentaireId =0;
      commentairesController.clear();
      _getCommentaires();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _deleteCommentaire(int commentaireId) async{
    ApiResponse response = await deleteCommentaires(commentaireId);
    if(response.error == null){
      _getCommentaires();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _createCommentaire() async{
    ApiResponse response = await createCommentaires(widget.postId!, commentairesController.text);
    if(response.error == null){
      commentairesController.clear();
      _getCommentaires();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
