class ApiEndpoints {
  static final bool isDevServer = true;

  static final String baseUrl = "${ApiEndpoints.url}";

  static final String devUrl = "http://3.22.251.222";
  static final String liveUrl = "http://3.22.251.222";

  static final String url = isDevServer ? devUrl : liveUrl;

  static final int port = 3000;
  static final String path = "";

  static final String login = "/users/login";
  static final String register = "/users/register";
  static final String resetPassword = "/users/resetPassword";
  static final String updateUser = "/users/update";

  static final String spots = "/spots";

  static final String createReservation = "/reservations/new";
  static final String endReservation = "/reservations/new";
  static final String getActiveReservation = "/reservations/active";
  static final String getHistoryReservation = "/reservations/history";
  static final String stopReservation = "/reservations/end";
}
