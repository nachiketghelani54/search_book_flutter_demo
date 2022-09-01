import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import "package:readmore/readmore.dart";
import 'package:search_book_flutter_demo/bloc/search_book_bloc.dart';
import 'package:search_book_flutter_demo/constant/color_config.dart';
import 'package:search_book_flutter_demo/constant/string_config.dart';
import 'package:search_book_flutter_demo/model/Items.dart';

import '../constant/size_config.dart';

class SearchListScreen extends StatefulWidget {
  const SearchListScreen({Key? key}) : super(key: key);

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {

  ///Final
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final SearchBookBloc _newsBloc = SearchBookBloc();
  final TextEditingController _searchController = TextEditingController();

  ///DataType
  int indexValue = 0;
  List<Items> userModel = [];
  int index = 0;
  bool isLoading = false;
  List<Items> bookSearch = [];

  ///OnInit
  @override
  void initState() {
    _newsBloc.add(GetSearchList(index: indexValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:_body(),
    );
  }

  ///AppBar
  _appBar(){
    return AppBar(
      backgroundColor: activeColor,
      title: const Text(titleString),
    );
  }

  ///body
  _body(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding10),
      child: Column(
        children: [
          height20,
          CupertinoSearchTextField(
            controller: _searchController,
            padding: const EdgeInsets.all(kPadding10),
            onChanged: (value) {
              setState(() {
                bookSearch = userModel
                    .where((element) => element.volumeInfo!.title!
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                    .toList();
              });
            },
            itemColor: activeColor,
            autocorrect: true,
            enabled: true,
          ),
          height20,
          BlocProvider(
            create: (_) => _newsBloc,
            child: BlocListener<SearchBookBloc, SearchBookState>(
                listener: (context, state) {
                  if (state is SearchError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                      ),
                    );
                  }
                }, child: BlocBuilder<SearchBookBloc, SearchBookState>(
              builder: (context, state) {
                if (isLoading == false) {
                  if (state is SearchBookInitial) {
                    return const CircularProgressIndicator();
                  } else if (state is SearchLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is SearchLoaded) {
                    for (int i = 0;
                    i < state.userModel[0].items!.length;
                    i++) {
                      userModel.add(state.userModel[0].items![i]);
                    }
                    return _searchBook(userModel);
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message.toString()));
                  }
                } else {
                  if (state is SearchBookInitial || state is SearchLoading) {
                    return _searchBook(userModel);
                  } else if (state is SearchLoaded) {
                    for (int i = 0;
                    i < state.userModel[0].items!.length;
                    i++) {
                      userModel.add(state.userModel[0].items![i]);
                    }
                    return _searchBook(userModel);
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message.toString()));
                  }
                }
                return const Text(noDataString);
              },
            )),
          ),
        ],
      ),
    );
  }

  ///SearchBook List
  Widget _searchBook(items) {
    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: _onLoading,
        header: const WaterDropHeader(waterDropColor: activeColor),
        onRefresh: _refresh,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? status) {
            Widget body;
            if (status == LoadStatus.idle) {
              body = const Text(fetchString);
            } else if (status == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (status == LoadStatus.failed) {
              body = const Text(loadingString);
            } else if (status == LoadStatus.canLoading) {
              body = const Text(releaseString);
            } else {
              body = const Text(noMoreString);
            }
            return SizedBox(
              height: kPadding55,
              child: Center(child: body),
            );
          },
        ),
        child: _searchController.text.isNotEmpty && bookSearch.isEmpty?
        _empty(searchString):
        items.isEmpty?
        _empty(bookString):
        ListView.separated(
            itemCount: _searchController.text.isNotEmpty
                ? bookSearch.length
                : items.length,
            itemBuilder: (context, index) {
              var item = _searchController.text.isNotEmpty ? bookSearch : items;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kPadding10),
                ),
                elevation: 3,
                child: Center(
                  child: ListTile(
                    title: Text(
                      item[index].volumeInfo!.title ?? '',
                      style: const TextStyle(
                          fontSize: font16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: ReadMoreText(
                      item[index].volumeInfo!.description ?? '',
                      style: const TextStyle(
                        fontSize: font12,
                        fontWeight: FontWeight.w400,
                        color: blackColor,
                      ),
                      trimLines: 3,
                      trimLength: 400,
                      colorClickableText: pinkColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: showMoreString,
                      trimExpandedText: showLessString,
                      moreStyle: const TextStyle(
                        color: activeColor,
                        fontSize: font12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Container(
                      width: kPadding60,
                      height: kPadding200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kPadding12),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                              item[index].volumeInfo!.imageLinks!.thumbnail ?? ''),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => divider),
      ),
    );
  }

  ///Empty
  _empty(text){
    return Center(child: Text(text));
  }

  ///Refresh
  _refresh() async {
    try {
      isLoading = false;
      userModel = [];
      index = indexValue;
      _newsBloc.add(GetSearchList(index: indexValue));
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  ///OnLoading
  _onLoading() async {
    isLoading = true;
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _newsBloc.add(GetSearchList(index: index++));
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    });
  }
}
