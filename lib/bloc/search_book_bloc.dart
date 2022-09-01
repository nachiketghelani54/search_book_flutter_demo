import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:search_book_flutter_demo/model/SearchBox.dart';
import 'package:search_book_flutter_demo/services/api_repository.dart';

part 'search_book_event.dart';
part 'search_book_state.dart';

class SearchBookBloc extends Bloc<SearchBookEvent, SearchBookState> {
  SearchBookBloc() : super(SearchBookInitial()) {
    final ApiRepository apiRepository = ApiRepository();
    on<GetSearchList>((event, emit) async {
      // TODO: implement event handler
      emit(SearchLoading());
      try {
        final listSearch = await apiRepository.getSearchIdList(event.index);
        emit(SearchLoaded(userModel: listSearch));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
}
