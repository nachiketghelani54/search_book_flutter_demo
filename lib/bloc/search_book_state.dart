part of 'search_book_bloc.dart';

abstract class SearchBookState extends Equatable {
    const SearchBookState();

    @override
    List<Object?> get props => [];
}

///Initial
class SearchBookInitial extends SearchBookState {}

///Loading
class SearchLoading extends SearchBookState {}

///Loaded
class SearchLoaded extends SearchBookState {
  final List<SearchBox> userModel;

  const SearchLoaded({required this.userModel});
}

///Error
class SearchError extends SearchBookState {
  final String? message;

  const SearchError(this.message);
}
