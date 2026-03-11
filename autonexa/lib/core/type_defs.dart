import 'package:fpdart/fpdart.dart';
import 'package:autonexa/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
