import 'package:dio/dio.dart';
import 'package:elderwise/data/api/api_config.dart';
import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';
import 'package:elderwise/domain/repositories/agenda_repository.dart';
import 'package:flutter/material.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  final Dio dio;

  AgendaRepositoryImpl({Dio? dio}) : dio = dio ?? ApiConfig.dio;

  @override
  Future<ResponseWrapper> getAgendaByID(String agendaId) async {
    final response = await dio.get(ApiConfig.getAgenda(agendaId));
    debugPrint(response.data);
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> createAgenda(AgendaRequestDTO agendaRequest) async {
    final response =
        await dio.post(ApiConfig.createAgenda, data: agendaRequest.toJson());
    debugPrint(response.data);
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> updateAgenda(
      String agendaId, AgendaRequestDTO agendaRequest) async {
    final response = await dio.put(ApiConfig.updateAgenda(agendaId),
        data: agendaRequest.toJson());
    debugPrint(response.data);
    return ResponseWrapper.fromJson(response.data);
  }

  @override
  Future<ResponseWrapper> deleteAgenda(String agendaId) async {
    final response = await dio.delete(ApiConfig.deleteAgenda(agendaId));
    debugPrint(response.data);
    return ResponseWrapper.fromJson(response.data);
  }
}
