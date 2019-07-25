import 'package:http_resource/http_resource.dart';

class Todo extends Model<Todo> {
  HttpClient httpClient = TodoClient();
  int userId;
  String title;
  String body;
  bool completed;

  Map<String, dynamic> get fields => {
        'id': this.id,
        'userId': userId,
        'title': title,
        'body': body,
        'completed': completed
      };

  @override
  Map<String, dynamic> setFields() => {
        "id": (value) => this.id = value,
        "userId": (value) => userId = value,
        "title": (value) => title = value,
        "body": (value) => body = value,
        "completed": (value) => completed = value,
      };
}

class TodoClient extends HttpClient<Todo> {
  @override
  String get apiUrl => 'https://jsonplaceholder.typicode.com/todos';

  @override
  Todo getInstance() {
    return Todo();
  }
}

void main() async {
  List<Todo> todo = await TodoClient().all();
  Todo test = await TodoClient().first(1);
  Todo create = Todo();
  create.userId = 1;
  create.title = 'testtitle';
  await create.create();
  create.id = 1;
  create.body = "trele body";
  await create.update();
}
