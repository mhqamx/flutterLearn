class ApiEndpoint {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // 首页
  static String get homeBanners => '/albums';
  static String get homeRecommend => '/posts';

  // 商城
  static String products({int page = 1, int limit = 20}) =>
      '/photos?_page=$page&_limit=$limit';
  static String productDetail(int id) => '/photos/$id';

  // 新闻
  static String newsList({int page = 1, int limit = 15}) =>
      '/posts?_page=$page&_limit=$limit';
  static String newsDetail(int id) => '/posts/$id';

  // 用户
  static String userProfile(int id) => '/users/$id';
  static String userPosts(int userId) => '/posts?userId=$userId';
}
