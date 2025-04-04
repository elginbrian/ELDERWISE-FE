import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/data/api/responses/response_wrapper.dart';

abstract class AgendaRepository {
  Future<ResponseWrapper> getAgendaByID(String agendaId);
  Future<ResponseWrapper> createAgenda(AgendaRequestDTO agendaRequest);
  Future<ResponseWrapper> updateAgenda(
      String agendaId, AgendaRequestDTO agendaRequest);
  Future<ResponseWrapper> deleteAgenda(String agendaId);
}
