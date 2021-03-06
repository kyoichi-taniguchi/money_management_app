import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/view_model/view_model.dart';

class EditView extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  final TodoItem todo;

  const EditView(
    this.viewModel,
    this.todo, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EditView> createState() => _EditViewState();
}

class _EditViewState extends ConsumerState<EditView> {
  late ViewModel _viewModel;
  late TodoItem todoItem;
  late TextEditingController _cashController;
  late TextEditingController _contentController;
  final DatabaseController _databaseController = DatabaseController();

  @override
  void initState() {
    super.initState();
    todoItem = widget.todo;
    _cashController = TextEditingController(text: todoItem.price.toString());
    _contentController = TextEditingController(text: todoItem.content);
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);

    Future(() async {
      await _databaseController.initDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          _viewModel.updateAvailableMoneyProvider(
              todoItem.price, int.parse(_cashController.text));
          Navigator.of(context).pop();
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('編集画面'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${todoItem.createdAt.month}月${todoItem.createdAt.day}日',
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    suffix: Text('円'),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _cashController,
                  onChanged: (_) async {
                    _databaseController.changePrice(
                        todoItem, int.parse(_cashController.text));
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: _contentController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
