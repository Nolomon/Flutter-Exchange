import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';
import '../../res/app_res.dart';
import '../../utils/app_toast.dart';
import '../../utils/helpers.dart';
import 'errors.dart';

class ErrorHandler<T> {
  final dynamic exception;
  final StackTrace? stackTrace;
  ErrorHandler({required this.exception, this.stackTrace}) {
    log('exception ${this.exception}');
    log(
      'stack trace  ${this.stackTrace}',
    );
  }

  ///Calssifies the exception into one of several helpful exception types, and throws it back.
  Exception rethrowError() {
    final e = this.exception;
    if (e is SocketException) {
      return NoInternetConnectionException<T>(
        message: S.current.noInternetConnection,
      );
    } else if (e is TimeoutException) {
      return NoInternetConnectionException<T>(
        message: S.current.noInternetConnection,
      );
    } else if (e is NoInternetConnectionException<T>) {
      return e;
    } else if (e is ServerException) {
      return ServerException<T>(
        message: e.message,
      );
    }if (e is ParsingException) {
      log('\n');
      log("can not parse response : ${e.message} ");
      log("stack : ${e.stack!}");
      log('\n');
      return UnknownException<T>(
        message: S.current.weakNetworkConnection,
      );
    }
    return UnknownException<T>(
      message: S.current.weakNetworkConnection,
    );
  }

  Widget buildErrorWidget({
    required BuildContext context,
    required VoidCallback retryCallback,
    String? iconPath,
    Color? iconColor,
    double? iconWidth,
    double? iconHeight,
    bool? hasLoader,
  }) {
    if (exception is NoInternetConnectionException ||
        exception is ServerException ||
        exception is UnknownException) {
      return ButtonErrorWidget(
        key: UniqueKey(),
        onPressed: retryCallback,
        message: exception.message,
        iconColor: iconColor,
        iconWidth: iconWidth,
        iconHeight: iconHeight,
        hasLoader: hasLoader,
      );
    }
    return ButtonErrorWidget(
      enableButton: false,
      onPressed: retryCallback,
      iconColor: iconColor,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      hasLoader: hasLoader,
    );
  }

  String getErrorMessage() {
    if (exception is NoInternetConnectionException) {
      return (exception as NoInternetConnectionException).message;
    }
    if (exception is ServerException) {
      return ((exception as ServerException).message) ?? S.current.serverError;
    }
    return S.current.weakNetworkConnection;
  }

  void handleError(BuildContext context, {Function? sessionExpiredOverride}) {
    log(exception.toString());
    final e = exception;
    if (e is NoInternetConnectionException ||
        e is ServerException ||
        e is UnknownException) {
      return AppToast(message: e.message).show();
    }
    AppToast(
      message: S.current.weakNetworkConnection,
    ).show();
  }
}


class ButtonErrorWidget extends StatefulWidget {
  final String? message;
  final String? iconPath;
  final double? iconWidth;
  final double? iconHeight;
  final TextStyle? textStyle;
  final TextStyle? buttonTextStyle;
  final VoidCallback? onPressed;
  final bool? enableButton;
  final Color? iconColor;
  final bool hasLoader;

  const ButtonErrorWidget({
    Key? key,
    this.message,
    this.iconPath,
    this.iconWidth,
    this.iconHeight,
    this.textStyle,
    required this.onPressed,
    this.buttonTextStyle,
    this.enableButton = true,
    this.iconColor,
    bool? hasLoader,
  })  : hasLoader = hasLoader ?? false,
        super(key: key);

  @override
  State<ButtonErrorWidget> createState() => _ButtonErrorWidgetState();
}

class _ButtonErrorWidgetState extends State<ButtonErrorWidget> {
  bool loaderShown = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (loaderShown) const CircularProgressIndicator(),
          if (!loaderShown)
            SvgPicture.asset(
              widget.iconPath ?? AppImages.error,
              fit: BoxFit.cover,
              color: widget.iconColor,
              width: widget.iconWidth,
              height: widget.iconHeight,
            ),
          if (!loaderShown)
            const SizedBox(
              height: 15,
            ),
          if (!loaderShown)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.message ??
                    (Helpers.isRTL(context)
                        ? 'حدث خطأ ما ، يرجى إعادة المحاولة لاحقاً'
                        : 'An error occured, please try again later'),
                style: widget.textStyle ??
                    TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          if (!loaderShown)
            const SizedBox(
              height: 10,
            ),
          if (widget.enableButton! && !loaderShown)
            OutlinedButton(
              onPressed: () {
                if (widget.hasLoader) {
                  setState(() {
                    loaderShown = !loaderShown;
                  });
                }
                widget.onPressed?.call();
              },
              child: Text(
                Helpers.isRTL(context) ? 'إعادة المحاولة' : "Try Again",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
