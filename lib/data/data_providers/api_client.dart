import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/app_res.dart';
import '../utils/api_deserializer.dart';
import '../utils/errors.dart';

class ApiClient {
  late final http.Client httpClient;
  late final SharedPreferences prefs;

  String? _langaugeCode;
  final String baseURL;

  ApiClient({
    required this.baseURL,
    required String languageCode,
  }) {
    httpClient = RetryClient(
      http.Client(),
      whenError: (error, stackTrace) => error is http.ClientException,
      onRetry: (request, response, currentRetryNumber) async {
        if (response == null) {
          log('${Constants.logYellow}ClientException when attempting to ${request.method} on ${request.url.toString()}\nRetry #$currentRetryNumber...');
        } else {
          log('${Constants.logYellow}HTTP error ${response.statusCode} ${response.reasonPhrase} when attempting to ${request.method} on ${request.url.toString()}\nRetry #$currentRetryNumber...');
        }
      },
    );
    _langaugeCode = languageCode;
  }

  ///Sets the language header for all network calls
  void setLanguageCode(String code) {
    _langaugeCode = code;
  }

  ///The language code used for network calls
  void get languageCode => _langaugeCode;

  ///Http request headers
  Map<String, String> head({String? contentType, String? auth, String? token}) {
    return {
      "Content-Type": contentType ?? "multipart/form-data",
      "Accept": "application/json",
      "Accept-Language": _langaugeCode!,
    };
  }

  ///Calls `path` based on `requestType` (defaults to POST).
  ///Returns a Future of the result model of type R after parsing the repsonse body.
  ///
  ///The `body` argument is for POST request body.
  ///The `files` argument is where files can be passed to the request as a list
  Future<R?> invokeApi<R>(
    String path, {
    String? hostUrl,
    ApiRequestType requestType = ApiRequestType.post,
    Map<String, String>? headers,
    Object body = const {},
    Map<String, File> namedFiles = const {},
    Map<String, List<File>> namedListsOfFiles = const {},
    List<File?> files = const [],
  }) async {
    log('${Constants.logBlue}CALLING ENDPOINT $path');
    log('REQUEST BODY $body');
    final Uri url = Uri.parse('${hostUrl ?? baseURL}$path');

    late final http.Response response;
    Map<String, String> requestHeaders = headers ?? head();
    try {
      if (requestType == ApiRequestType.head) {
        response = await httpClient.head(url, headers: requestHeaders);
        return response.headers as R;
      } else if (requestType == ApiRequestType.bytes) {
        response = await httpClient.get(url, headers: requestHeaders);
        return response.bodyBytes as R;
      } else if (requestType == ApiRequestType.get) {
        response = await httpClient.get(url, headers: requestHeaders);
      } else if (requestType == ApiRequestType.post ||
          requestType == ApiRequestType.put) {
        if (requestHeaders["Content-Type"]?.toLowerCase() !=
                "multipart/form-data" &&
            namedFiles.isEmpty &&
            namedListsOfFiles.isEmpty &&
            files.isEmpty) {
          if (requestType == ApiRequestType.post) {
            response = await httpClient.post(
              url,
              headers: requestHeaders,
              body: body,
            );
          } else if (requestType == ApiRequestType.put) {
            response = await httpClient.post(
              url,
              headers: requestHeaders,
              body: body,
            );
          }
        } else {
          //* Adding text fields
          Map<String, String> requestBody = {};
          (body as Map).forEach((key, value) {
            requestBody[key.toString()] = value.toString();
          });
          var request = http.MultipartRequest(
            requestType == ApiRequestType.post ? 'POST' : 'PUT',
            url,
          );
          request.headers.addAll(requestHeaders);
          request.fields.addAll(requestBody);
          //* Adding named files
          for (final MapEntry<String, File> namedFile in namedFiles.entries) {
            request.files.add(await http.MultipartFile.fromPath(
              namedFile.key,
              namedFile.value.path,
              contentType:
                  MediaType('file', namedFile.value.path.split(".").last),
            ));
          }
          //* Adding named lists of files
          for (final MapEntry<String, List<File>> namedFilesList
              in namedListsOfFiles.entries) {
            for (final file in namedFilesList.value) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  namedFilesList.key,
                  file.path,
                  contentType: MediaType('file', file.path.split(".").last),
                ),
              );
            }
          }
          //* Adding unnamed files
          for (var file in files) {
            request.files.add(
              await http.MultipartFile.fromPath(
                file!.path.split(".").first,
                file.path,
                contentType: MediaType('file', file.path.split(".").last),
              ),
            );
          }
          //* Sending the file(s) as a stream
          var streamedResponse = await httpClient.send(request);
          //* Awaiting for the complete request to finish uploading.
          response = await http.Response.fromStream(streamedResponse);
        }
      } else if (requestType == ApiRequestType.delete) {
        response = await httpClient.delete(url, headers: requestHeaders);
      }

      log('REQUEST HEADERS ${response.request?.headers.toString()}');
      log('${Constants.logCyan}STATUS CODE ${response.statusCode}');
      log('RESPONSE BODY ${response.body}');
      String source = const Utf8Decoder().convert(response.bodyBytes);
      if (response.statusCode >= 400) {
        String? message;
        if (json.decode(source)["message"]?.isNotEmpty ?? false) {
          message = json.decode(source)["message"];
        } else {
          message =
              json.decode(source)["error"] ?? json.decode(source)["error-type"];
        }
        throw ServerException<R>(message: message);
      }

      return ApiDeserializer<R>(rawJson: response.body).deserialize() as R;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }
}

///An enum for the types of used HTTP calls
enum ApiRequestType {
  get,
  post,
  put,
  delete,
  head,
  bytes,
}
