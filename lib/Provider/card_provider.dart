import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  List<String> _urlImage = [];
  List<String> get urlImage => _urlImage;

  List<String> _name = [];
  List<String> get name => _name;

  bool _isDragging = false;
  bool get isDragging => _isDragging;

  double _angle = 0;
  double get angle => _angle;

  Size _screenSize = Size.zero;

  Offset _position = Offset.zero;
  Offset get position => _position;

  CardProvider() {
    resetUser();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toUpperCase(),
        fontSize: 36,
      );
    }

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superlike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    if (force) {
      final delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      final delta = 20;

      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superLike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (y <= -delta) {
        return CardStatus.dislike;
      }
    }
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void superlike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImage.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));

    _urlImage.removeLast();
    resetPosition();
  }

  void resetUser() {
    _urlImage = <String>[
      /////RESİMLER
      'https://images.unsplash.com/photo-1571988840298-3b5301d5109b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
      'https://images.unsplash.com/photo-1506755855567-92ff770e8d00?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
      'https://images.unsplash.com/photo-1606491048802-8342506d6471?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTF8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    ].reversed.toList();

    _name = <String>[
      ///isimler
      'Karamel',
      'Pati',
      'Limon',
    ].reversed.toList();

    notifyListeners();
  }
}
