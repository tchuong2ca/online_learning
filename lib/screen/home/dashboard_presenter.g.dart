// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardPresenter on _DashboardPresenter, Store {
  late final _$seeMoreAtom =
      Atom(name: '_DashboardPresenter.seeMore', context: context);

  @override
  bool get seeMore {
    _$seeMoreAtom.reportRead();
    return super.seeMore;
  }

  @override
  set seeMore(bool value) {
    _$seeMoreAtom.reportWrite(value, super.seeMore, () {
      super.seeMore = value;
    });
  }

  late final _$heightAtom =
      Atom(name: '_DashboardPresenter.height', context: context);

  @override
  bool get height {
    _$heightAtom.reportRead();
    return super.height;
  }

  @override
  set height(bool value) {
    _$heightAtom.reportWrite(value, super.height, () {
      super.height = value;
    });
  }

  late final _$_DashboardPresenterActionController =
      ActionController(name: '_DashboardPresenter', context: context);

  @override
  void onSeeMoreClick() {
    final _$actionInfo = _$_DashboardPresenterActionController.startAction(
        name: '_DashboardPresenter.onSeeMoreClick');
    try {
      return super.onSeeMoreClick();
    } finally {
      _$_DashboardPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setHeight(dynamic value) {
    final _$actionInfo = _$_DashboardPresenterActionController.startAction(
        name: '_DashboardPresenter.setHeight');
    try {
      return super.setHeight(value);
    } finally {
      _$_DashboardPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
seeMore: ${seeMore},
height: ${height}
    ''';
  }
}
