import 'dart:io';

import 'package:app_buy_sell/src/features/home/domain/app_model.dart';
import 'package:app_buy_sell/src/features/product/data/pay_repository.dart';
import 'package:app_buy_sell/src/features/product/data/pay_service.dart';
import 'package:app_buy_sell/src/features/product/domain/apple_payment_model.dart';
import 'package:app_buy_sell/src/features/product/domain/google_payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pay/pay.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_controller.g.dart';

@riverpod
class ProductController extends _$ProductController {
  @override
  FutureOr<AppModel> build(AppModel appModel) async {
    final didPay = await _loadPay(appModel);
    final app = appModel.copyWith(didPay: didPay);
    return app;
  }

  Future<bool> _loadPay(AppModel appModel) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('app')
        .doc(appModel.id)
        .get();
    if (snapshot.data() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> pay(AppModel appModel) async {
    final paymentItems = [
      PaymentItem(
        label: '購入するアプリ',
        amount: appModel.price,
        status: PaymentItemStatus.final_price,
      )
    ];
    if (Platform.isIOS) {
      final result = await PayService(ApplePayImpl()).pay(paymentItems);
      final applePayment = ApplePaymentModel.fromJson(result);
      await saveApplePayment(applePayment, appModel);
    } else {
      final result = await PayService(GoolePayImpl()).pay(paymentItems);
      final goolePayment = GooglePaymentModel.fromJson(result);
      await saveGooglePayment(goolePayment, appModel);
    }
  }

  Future<void> saveGooglePayment(
      GooglePaymentModel payment, AppModel appModel) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('app')
        .doc(appModel.id)
        .set(payment.toJson());
    state = AsyncData(appModel.copyWith(paySuccess: true, didPay: true));
  }

  Future<void> saveApplePayment(
      ApplePaymentModel payment, AppModel appModel) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('app')
        .doc(appModel.id)
        .set(payment.toJson());
    state = AsyncData(appModel.copyWith(paySuccess: true, didPay: true));
  }
}
