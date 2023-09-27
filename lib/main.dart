import 'package:flutter/material.dart';
import 'dart:async';

// ignore: constant_identifier_names
const WIDTH = 10;
// ignore: constant_identifier_names
const HEIGHT = 10;
// ignore: constant_identifier_names
const SNAKE_COLOR = Colors.blueAccent;
// ignore: constant_identifier_names
const TICK = 100;

void main() {
  runApp(const MyApp());
}

enum Direction { left, right, up, down, none }

dynamic constantDirectionInfos = {
  'direction': Direction.none,
  'isFirst': true,
  'startRowIndex': 1,
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Simple snake game"),
          ),
          body: SnakeGame()),
    );
  }
}

// ignore: must_be_immutable
class SnakeGame extends StatefulWidget {
  SnakeGame({super.key});

  List<int> snakePositions = [23];
  Direction direction = constantDirectionInfos['direction'];

  List<bool> generateColoredGridTable() {
    return List.generate(
        WIDTH * HEIGHT,
        (index) =>
            snakePositions.any((positionIndex) => positionIndex == index));
  }

  @override
  SnakeGameState createState() => SnakeGameState();
}

class SnakeView extends State<SnakeGame> {
  @override
  // ignore: prefer_typing_uninitialized_variables
  final widget;
  SnakeView(this.widget);
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 300,
        child: GridView.count(crossAxisCount: WIDTH, children: <Widget>[
          ...widget.generateColoredGridTable().map((isSquareFilled) {
            final Widget element = Container(
              decoration: BoxDecoration(
                  border: Border.all(color: SNAKE_COLOR),
                  color: isSquareFilled ? SNAKE_COLOR : null),
            );

            return element;
          })
        ]));
  }
}

int removeLastCharInIntNumber(int number) {
  final List<String> stringArray = number.toString().split('').toList();
  if (stringArray.length > 1) {
    stringArray.removeLast();
  }

  return number > 9 ? (int.parse(stringArray.join('')) + 1) : 1;
}

void configureConstantDirectionInfos(Direction direction) {
  if (constantDirectionInfos['direction'] != direction) {
    constantDirectionInfos = {
      'direction': direction,
      'isFirst': true,
      'startRowIndex': 1,
    };
  }
}

class SnakeGameState extends State<SnakeGame> {
  void moveSnake() {
    switch (widget.direction) {
      case Direction.right:
        setState(() {
          configureConstantDirectionInfos(Direction.right);
          int counter = 0;

          widget.snakePositions =
              widget.snakePositions.reversed.map<int>((position) {
            int newPosition = 0;
            if (counter == 0 && constantDirectionInfos['isFirst']) {
              constantDirectionInfos['isFirst'] = false;
              constantDirectionInfos['startRowIndex'] =
                  removeLastCharInIntNumber(position + 1);
            }

            int actuallyRowIndex = removeLastCharInIntNumber(position + 1);
            actuallyRowIndex = actuallyRowIndex == 0 ? 1 : actuallyRowIndex;

            if (actuallyRowIndex > constantDirectionInfos['startRowIndex']) {
              newPosition = position - WIDTH + 1;
            } else {
              newPosition = position + 1;
            }

            counter++;

            return newPosition;
          }).toList();
        });
        break;

      case Direction.left:
        setState(() {
          int counter = 0;
          configureConstantDirectionInfos(Direction.left);

          widget.snakePositions = widget.snakePositions.map<int>((position) {
            int newPosition = 0;
            if (counter == 0 && constantDirectionInfos['isFirst']) {
              constantDirectionInfos['isFirst'] = false;
              constantDirectionInfos['startRowIndex'] =
                  removeLastCharInIntNumber(position);
            }

            int actuallyRowIndex = removeLastCharInIntNumber(position - 1);
            actuallyRowIndex = actuallyRowIndex == 0 ? 1 : actuallyRowIndex;

            if (actuallyRowIndex < constantDirectionInfos['startRowIndex']) {
              newPosition = position + WIDTH - 1;
            } else {
              newPosition = position - 1;
            }

            counter++;

            return newPosition;
          }).toList();
        });
        break;

      case Direction.down:
        setState(() {
          configureConstantDirectionInfos(Direction.down);

          widget.snakePositions = widget.snakePositions.map<int>((position) {
            int newPosition = 0;
            int actuallyRowIndex = removeLastCharInIntNumber(position);
            actuallyRowIndex = actuallyRowIndex == 0 ? 1 : actuallyRowIndex;

            if (actuallyRowIndex + 1 >=
                removeLastCharInIntNumber(WIDTH * HEIGHT)) {
              newPosition = position - (WIDTH * HEIGHT) + WIDTH;
            } else {
              newPosition = position + WIDTH;
            }

            return newPosition;
          }).toList();
        });
        break;

      case Direction.up:
        setState(() {
          configureConstantDirectionInfos(Direction.down);

          widget.snakePositions = widget.snakePositions.map<int>((position) {
            int newPosition = 0;
            int actuallyRowIndex = removeLastCharInIntNumber(position);
            actuallyRowIndex = actuallyRowIndex <= 0 ? 1 : actuallyRowIndex;

            if (actuallyRowIndex - 1 <= 0) {
              newPosition = position + (WIDTH * HEIGHT) - WIDTH;
            } else {
              newPosition = position - WIDTH;
            }

            return newPosition;
          }).toList();
        });

        break;

      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: TICK), (timer) {
      moveSnake();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              SnakeView(widget).build(context),
              const SizedBox(height: 30),
              SizedBox(
                  width: 250,
                  height: 250,
                  child: GridView.count(crossAxisCount: 3, children: <Widget>[
                    const Text(''),
                    TextButton(
                      child: const Icon(Icons.keyboard_arrow_up_outlined),
                      onPressed: () {
                        widget.direction = Direction.up;
                      },
                    ),
                    const Text(''),
                    TextButton(
                      child: const Icon(Icons.keyboard_arrow_left_outlined),
                      onPressed: () {
                        widget.direction = Direction.left;
                      },
                    ),
                    TextButton(
                      child: const Icon(Icons.block_outlined),
                      onPressed: () {
                        widget.direction = Direction.none;
                      },
                    ),
                    TextButton(
                      child: const Icon(Icons.keyboard_arrow_right_outlined),
                      onPressed: () {
                        widget.direction = Direction.right;
                      },
                    ),
                    const Text(''),
                    TextButton(
                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                      onPressed: () {
                        widget.direction = Direction.down;
                      },
                    ),
                    const Text(''),
                  ]))
            ])));
  }
}
