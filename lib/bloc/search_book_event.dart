part of 'search_book_bloc.dart';

@immutable
abstract class SearchBookEvent extends Equatable {
  const SearchBookEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class GetSearchList extends SearchBookEvent {
  int index = 0;

  GetSearchList({required this.index});
}