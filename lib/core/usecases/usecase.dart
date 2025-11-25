import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// [Type] is the return type of the use case
/// [Params] is the type of parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this class when use case doesn't require any parameters
class NoParams {
  const NoParams();
}
