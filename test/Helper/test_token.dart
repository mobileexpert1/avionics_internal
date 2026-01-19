class TestToken {
  TestToken._privateConstructor();
  static final TestToken instance = TestToken._privateConstructor();

  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2ZGU2YTM4Ni01YzhkLTQxNzctYWM1Yi01NmYwNzVjMDg4OGUiLCJ0b2tlbl90eXBlIjoiYWNjZXNzIiwidG9rZW5faWQiOiI4ZjdhMGVlMC1iMjI3LTQ5MTQtOTNlYy02ZjMwZDZmOTk2NjUtMjAyNi0wMS0wNjA3OjIyOjMzLjU2NTY5OTZkZTZhMzg2LTVjOGQtNDE3Ny1hYzViLTU2ZjA3NWMwODg4ZSIsImV4cCI6MTc2Nzc3MDU1M30.Whxpx-Ae351hHqocleusowQpAts6L3TREV-2TY7XaBs';

  void setToken(String value) {
    token = value;
  }

  String get getToken => token;
}
