import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constant/color.dart';
import '../widget/todo_item.dart';

// void main() {
//   runApp(Home());
// }

class Home extends StatefulWidget {
  Home({Key? key}): super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 50,
                            bottom: 20
                        ),
                        child: Text(
                            'All ToDos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),

                      for ( ToDo todoo in _foundToDo)
                      ToDoItem(
                        todo: todoo,
                        onToDoChanged: _handleToDoChange,
                        onDeleteItem: _deleteToDoItem,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row( children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                  left: 20,
                ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5
                    ),
                    decoration: BoxDecoration(
                      color: light_gray,
                      boxShadow: [BoxShadow(
                        color: light_gray,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0
                      ),],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a new todo..',
                        border: InputBorder.none
                      ),
                    ),
              ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white
                    ),
                  ),
                  onPressed: () {
                    _addTodoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: light_brown,
                    minimumSize: Size(60, 60),
                    elevation: 10
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });

  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }
  
  void _addTodoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todoController.clear();
  }

  void _runFilter(String enterKeyword) {
    List<ToDo> results = [];
    if( enterKeyword.isEmpty) {
      results = todosList;
    } else{
      results = todosList
      .where((item) => item.todoText!
          .toLowerCase()
          .contains(enterKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: light_gray,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefix: Icon(
                  Icons.search,
                  color: light_gray,
                  size: 20
                ),
                prefixIconConstraints: BoxConstraints(
                    maxHeight: 20,
                    minWidth: 20
                ),
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: light_gray),

              ),
            ),
          );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: dark_brown,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('/img/ic_profile.png'),
            ),
          )
        ]),
    );
  }
}
