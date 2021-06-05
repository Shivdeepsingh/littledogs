import 'package:flutter/material.dart';
import 'package:littledog/modals/chat.dart';
import 'package:littledog/modals/order.dart';
import 'package:littledog/modals/post.dart';
import 'package:littledog/modals/products.dart';
import 'package:littledog/modals/register.dart';
import 'package:littledog/modals/user.dart';

import 'cart.dart';
import 'otheruser.dart';
import 'petdetails.dart';

class AppState with ChangeNotifier {
  final cart = Cart();
  final register = Register();
  final user = User();
  final post = Post();
  final products = Products();
  final petDetails = PetDetails();
  final otherUser = OtherUser();
  final order = Order();
  final chat = Chat();

  notifyChange() {
    notifyListeners();
  }

  AppState();
}
