import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/dashboard_mechanic/repository/mechanic_repository.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';

final mechanicControllerProvider = Provider((ref) {
  return MechanicController(
    mechanicRepository: ref.read(mechanicRepositoryProvider),
    ref: ref,
  );
});

final pendingJobsProvider = StreamProvider<List<ServiceRequestModel>>((ref) {
  final mechanicController = ref.watch(mechanicControllerProvider);
  return mechanicController.getPendingJobs();
});

final activeJobsProvider = StreamProvider<List<ServiceRequestModel>>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) {
    return Stream.value([]);
  }
  final mechanicController = ref.watch(mechanicControllerProvider);
  return mechanicController.getActiveJobs(user.id);
});

class MechanicController {
  final MechanicRepository _mechanicRepository;
  MechanicController({
    required MechanicRepository mechanicRepository,
    required Ref ref, // keep for symmetry if standard, or just remove
  })  : _mechanicRepository = mechanicRepository;

  Stream<List<ServiceRequestModel>> getPendingJobs() {
    return _mechanicRepository.getPendingJobs();
  }

  Stream<List<ServiceRequestModel>> getActiveJobs(String mechanicId) {
    return _mechanicRepository.getActiveJobs(mechanicId);
  }
}
