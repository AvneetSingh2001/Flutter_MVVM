import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/tasks.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  void _AddTask() {
    FirebaseFirestore.instance
        .collection("todos")
        .add({"title": _controller.text});

    _controller.text = "";
  }

  Widget _buildList(QuerySnapshot? snapshot) {
    return ListView.builder(
      itemCount: snapshot!.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        final task = Task.fromSnapshot(doc);
        return _buildListItem(task);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: "Enter new Task"),
              )),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {
                  _AddTask();
                },
                child: const Text(
                  "Add Task",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent)),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("todos").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Expanded(
                  child: LinearProgressIndicator(),
                );
              else
                return Expanded(
                  child: _buildList(snapshot.data),
                );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: _buildBody(context),
    );
  }
}

Widget _buildListItem(Task task) {
  return ListTile(
    title: Text(task.taskId),
  );
}
