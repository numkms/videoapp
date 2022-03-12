import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'asset_import_state.dart';

class AssetImportCubit extends Cubit<AssetImportState> {
  AssetImportCubit() : super(AssetImportInitial());
}
