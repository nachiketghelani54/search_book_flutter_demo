
///String
const String titleString = 'Search Book';
const String errorString = 'Failed to load User';
const String showMoreString = 'Show more';
const String showLessString = 'Show less';
const String fetchString = 'fetching more';
const String loadingString = 'loading failed';
const String releaseString = 'release fetch more';
const String noMoreString = 'no more data';
const String noDataString = 'No data Found';
const String searchString = 'Search result not found';
const String bookString = 'Book not found';




///api Url
const String apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=search+terms';
String apiSearchUrl(int index) => 'https://www.googleapis.com/books/v1/volumes?q=\$searchItem&$index=10';

