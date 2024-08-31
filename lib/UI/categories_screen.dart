import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Models/CategoriesModel.dart';

import '../View_Model/News_View_Model.dart';
import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  Filters? selectedMenu;

  String categoryName = 'general';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height *1;
    final width = MediaQuery.sizeOf(context).width *1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        categoryName = categoriesList[index];
                        setState(() {
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: categoryName == categoriesList[index] ? Colors.blue: Colors.grey
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(fontSize: 13,color: Colors.white),),),
                          ),
                        ),
                      ),
                    );

              }),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoriesModel>(
                future:newsViewModel.getcategoriesapi(categoryName),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
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
            ),
      ),
    );
  }
}
