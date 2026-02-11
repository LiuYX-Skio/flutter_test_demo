import 'package:flutter/material.dart';
import '../api/mine_api.dart';
import '../models/mine_models.dart';

class MonthPayViewModel extends ChangeNotifier {
  MineCreditEntity? _mineCredit;
  UserMonthPayEntity? _monthPayData;
  bool _isLoading = false;
  String? _errorMessage;

  MineCreditEntity? get mineCredit => _mineCredit;
  UserMonthPayEntity? get monthPayData => _monthPayData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMineCredit({bool showLoading = false}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    await MineApi.getMineCredit(
      onSuccess: (data) {
        _mineCredit = data;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = exception.message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchMonthPayList({
    required String year,
    required String month,
    bool showLoading = false,
  }) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    await MineApi.getUserMonthPayList(
      year: year,
      month: month,
      onSuccess: (data) {
        _monthPayData = data;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = exception.message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
