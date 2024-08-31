import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Repository/New_Repository.dart';
import 'package:news_app/UI/categories_screen.dart';
import 'package:news_app/UI/news_detail_screen.dart';
import 'package:news_app/View_Model/News_View_Model.dart';

import '../Models/CategoriesModel.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}
enum Filters {bbcNews,aryNews,MedicalNews,AssocaitedNews,cnn,}

class _Home_screenState extends State<Home_screen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  Filters? selectedMenu;

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height *1;
    final width = MediaQuery.sizeOf(context).width *1;
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<Filters>(
                initialValue:selectedMenu ,
                onSelected: (Filters item){
                  if(Filters.bbcNews == item.name){
                    name ="bbc-news";
                  }
                  if(Filters.aryNews.name ==item.name){
                    name ='ary-news';
                  }
                  if(Filters.cnn.name == item.name){
                    name = 'cnn';
                  }
                  if(Filters.AssocaitedNews.name == item.name){
                    name = 'associated-press';
                  }
                  if(Filters.MedicalNews.name == item.name){
                    name = 'medical-news-today';
                  }
                  setState(() {
                    selectedMenu=item;
                  });
                },
                itemBuilder: (context)=> <PopupMenuEntry<Filters>>[
                  PopupMenuItem<Filters>(
                    value:Filters.bbcNews,
                    child:Text('BBC News') ,
                  ),
                  PopupMenuItem<Filters>(
                    value:Filters.aryNews,
                    child:Text('ARY News') ,
                  ),
                  PopupMenuItem(
                      value: Filters.MedicalNews,
                      child: Text('MedicalNews')),
                  PopupMenuItem(
                      value: Filters.AssocaitedNews,
                      child: Text('Assocaited_Press_News')),
                  PopupMenuItem(
                      value: Filters.cnn,
                      child: Text('CNN News')),
                ]),

          ],
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return CategoriesScreen();
              }));
            },
            icon: Image.asset('images/category_icon.png',
              height: 30,
              width: 30,),
          ),
          title: Text('News',style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w700),),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder(
                future:newsViewModel.getnewsapi(name),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount:snapshot.data!.articles!.length ,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return NewsDetailScreen(
                                    newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newsTitle: snapshot.data!.articles![index].title.toString(),
                                    newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    author: snapshot.data!.articles![index].author.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                    source: snapshot.data!.articles![index].source!.name.toString());

                              }));

                            },
                            child: SizedBox(
                              child: Stack(
                                  alignment: Alignment.center,
                                  children:[
                                    Container(
                                      height:height * 0.6,
                                      width: width * .6,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: height * .02,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context,Url){
                                            return
                                              SpinKitCircle(
                                                size: 50,
                                                color: Colors.amber,
                                              );
                                          },
                                          errorWidget: (context,Url,error) => Icon(Icons.error_outline,color: Colors.red,),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      child: Card(
                                        elevation: 5,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          alignment: Alignment.bottomCenter,
                                          height: height * .22,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: width * 0.5,
                                                child: Text(snapshot.data!.articles![index].title.toString(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.clip,
                                                  style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: width * 0.5,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(snapshot.data!.articles![index].source!.name.toString(),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600),),
                                                    Text(format.format(datetime),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.clip,
                                                      style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          );
                        });
                  }else{
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<CategoriesModel>(
                future:newsViewModel.getcategoriesapi('General'),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        shrinkWrap:true ,
                        itemCount:snapshot.data!.articles!.length ,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,index){
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius:BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context,Url){
                                        return
                                          Container(
                                            child: SpinKitCircle(
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          );
                                      },
                                      errorWidget: (context,Url,error) => Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: height * .18,
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: [
                                            Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(format.format(datetime),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,

                                                  ),
                                                )

                                              ],
                                            ),

                                          ],
                                        ),
                                      )),

                                ],
                              ),
                            ),
                          );
                        });
                  }else{
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}