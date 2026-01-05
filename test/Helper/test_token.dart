class TestToken {
  TestToken._privateConstructor();
  static final TestToken instance = TestToken._privateConstructor();

  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2ZGU2YTM4Ni01YzhkLTQxNzctYWM1Yi01NmYwNzVjMDg4OGUiLCJ0b2tlbl90eXBlIjoiYWNjZXNzIiwidG9rZW5faWQiOiIyNDU3NDA5ZC1jM2MwLTQxNTYtYjg5My00ZDlhNzY5NTU4MjQtMjAyNi0wMS0wNTEwOjM2OjEyLjIwMzAxNDZkZTZhMzg2LTVjOGQtNDE3Ny1hYzViLTU2ZjA3NWMwODg4ZSIsImV4cCI6MTc2NzY5NTc3Mn0.P4KwzbraaYWApksyJiBqdYBtZXU2nht3ppSmHyoYT84';

  void setToken(String value) {
    token = value;
  }

  String get getToken => token;
}
