import 'package:equatable/equatable.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';

class GetData {
  final Location location;
  final String image;
  final String title;
  final String description;
  const GetData({
    this.location = const Location(),
    this.image = '',
    this.title = '',
    this.description = '',
  });
}

class GetDataState extends Equatable {
  final GetData getData;
  final bool isLoading;
  final String? error;
  const GetDataState(
      {this.isLoading = false, this.error, this.getData = const GetData()});

  GetDataState copyWith({
    GetData? getData,
    bool? isLoading,
    String? error,
  }) =>
      GetDataState(
        getData: getData ?? this.getData,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [getData, isLoading, error];
}
