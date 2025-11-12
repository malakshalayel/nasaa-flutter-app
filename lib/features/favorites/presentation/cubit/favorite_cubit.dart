import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/features/favorites/data/repo/favorite_repo.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo _repository;

  FavoriteCubit(this._repository) : super(const FavoriteInitial()) {
    // loadFavorites();
    _loadFromCache();
  }

  // ✅ تحميل من cache عند بداية التطبيق

  Future<void> _loadFromCache() async {
    try {
      final cachedIds = CacheHelper.getString(key: CacheKeys.favoriteKey);

      if (cachedIds != null && cachedIds.isNotEmpty) {
        final List<dynamic> decodedIds = jsonDecode(cachedIds);
        final Set<int> favoriteIds = decodedIds.map((e) => e as int).toSet();

        log('✅ Loaded ${favoriteIds.length} favorites from cache');
        emit(FavoriteLoaded(favoriteIds: favoriteIds));
      } else {
        log('⚠️ No cached favorites found');
      }
    } catch (e) {
      log('❌ Error loading favorites from cache: $e');
    }
  }

  // ✅ حفظ في cache
  Future<void> _saveToCache(Set<int> favoriteIds) async {
    try {
      final encodedIds = jsonEncode(favoriteIds.toList());
      await CacheHelper.set(key: CacheKeys.favoriteKey, value: encodedIds);
      log('✅ Saved ${favoriteIds.length} favorites to cache');
    } catch (e) {
      log('❌ Error saving favorites to cache: $e');
    }
  }

  Future<void> loadFavorites() async {
    emit(FavoriteLoading());
    try {
      final response = await _repository.getFavoriteCoachesids();
      response.when(
        onSuccess: (ids) {
          _saveToCache(ids);
          emit(FavoriteLoaded(favoriteIds: ids));
        },
        onError: (message) {
          _loadFromCache();

          emit(const FavoriteLoaded(favoriteIds: {}));
        },
      );
    } catch (e) {
      _loadFromCache();

      emit(const FavoriteLoaded(favoriteIds: {}));
    }
  }

  Future<void> toggleFavorite(int coachId) async {
    final currentState = state;

    if (currentState is! FavoriteLoaded) return;

    final updatedIds = Set<int>.from(currentState.favoriteIds);
    final wasAdded = !updatedIds.remove(coachId);

    if (wasAdded) {
      updatedIds.add(coachId);
    }

    emit(currentState.copyWith(favoriteIds: updatedIds));

    try {
      final success = wasAdded
          ? await _repository.addCoachToFavorites(coachId)
          : await _repository.removeCoachFromFavorites(coachId);

      success.when(
        onSuccess: (message) {
          _saveToCache(updatedIds);
          emit(FavoriteLoaded(favoriteIds: updatedIds));
        },

        onError: (message) => emit(currentState),
      );
    } catch (e) {
      emit(currentState);
    }
  }

  bool isFavorite(int coachId) {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      return currentState.isFavorite(coachId);
    }
    return false;
  }
}
// lib/features/favorites/presentation/cubit/favorite_cubit.dart

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nasaa/config/cache_helper.dart';
// import 'package:nasaa/features/favorites/data/repo/favorite_repo.dart';
// import 'favorite_state.dart';

// class FavoriteCubit extends Cubit<FavoriteState> {
//   final FavoriteRepo _repo;

//   FavoriteCubit(this._repo) : super(FavoriteInitial()) {
//     // ✅ تحميل المفضلات من cache عند إنشاء الـ Cubit
//     _loadFromCache();
//   }

//   // ✅ تحميل من cache عند بداية التطبيق
//   Future<void> _loadFromCache() async {
//     try {
//       final cachedIds = CacheHelper.getString(key: 'favorite_coach_ids');

//       if (cachedIds != null && cachedIds.isNotEmpty) {
//         final List<dynamic> decodedIds = jsonDecode(cachedIds);
//         final Set<int> favoriteIds = decodedIds.map((e) => e as int).toSet();

//         log('✅ Loaded ${favoriteIds.length} favorites from cache');
//         emit(FavoriteLoaded(favoriteIds: favoriteIds));
//       } else {
//         log('⚠️ No cached favorites found');
//       }
//     } catch (e) {
//       log('❌ Error loading favorites from cache: $e');
//     }
//   }

//   // ✅ حفظ في cache
//   Future<void> _saveToCache(Set<int> favoriteIds) async {
//     try {
//       final encodedIds = jsonEncode(favoriteIds.toList());
//       await CacheHelper.set(key: 'favorite_coach_ids', value: encodedIds);
//       log('✅ Saved ${favoriteIds.length} favorites to cache');
//     } catch (e) {
//       log('❌ Error saving favorites to cache: $e');
//     }
//   }

//   // ✅ تحميل المفضلات من السيرفر
//   Future<void> loadFavorites() async {
//     emit(FavoriteLoading());

//     try {
//       log('📡 Loading favorites from server...');

//       final result = await _repo.getFavoriteCoachesids();

//       result.when(
//         onSuccess: (favorites) {
//           // // استخراج الـ IDs من الـ response
//           // final Set<int> favoriteIds =
//           //     favorites.map((coach) => coach.).toSet();

//           // log('✅ Loaded ${favoriteIds.length} favorites from server');
//           // log('✅ Favorite IDs: $favoriteIds');

//           // ✅ حفظ في cache
//           _saveToCache(favorites);

//           emit(FavoriteLoaded(favoriteIds: favorites));
//         },
//         onError: (error) {
//           log('❌ Error loading favorites: ${error.message}');

//           // ✅ في حالة الخطأ، استخدم الـ cache
//           _loadFromCache();

//           emit(FavoriteError(error.message));
//         },
//       );
//     } catch (e) {
//       log('❌ Exception loading favorites: $e');

//       // ✅ في حالة الخطأ، استخدم الـ cache
//       _loadFromCache();

//       emit(FavoriteError(e.toString()));
//     }
//   }

//   // ✅ إضافة/إزالة من المفضلة
//   Future<void> toggleFavorite(int coachId) async {
//     final currentState = state;

//     if (currentState is! FavoriteLoaded) {
//       log('⚠️ Cannot toggle favorite: state is not FavoriteLoaded');
//       return;
//     }

//     final favoriteIds = Set<int>.from(currentState.favoriteIds);
//     final isFavorited = favoriteIds.contains(coachId);

//     try {
//       if (isFavorited) {
//         // إزالة من المفضلة
//         log('💔 Removing coach $coachId from favorites');

//         final result = await _repo.removeCoachFromFavorites(coachId);

//         result.when(
//           onSuccess: (_) {
//             favoriteIds.remove(coachId);
//             log('✅ Coach $coachId removed from favorites');

//             // ✅ حفظ في cache
//             _saveToCache(favoriteIds);

//             emit(FavoriteLoaded(favoriteIds: favoriteIds));
//           },
//           onError: (error) {
//             log('❌ Error removing favorite: ${error.message}');
//             emit(FavoriteError(error.message));

//             // Restore previous state
//             emit(currentState);
//           },
//         );
//       } else {
//         // إضافة للمفضلة
//         log('❤️ Adding coach $coachId to favorites');

//         final result = await _repo.addCoachToFavorites(coachId);

//         result.when(
//           onSuccess: (_) {
//             favoriteIds.add(coachId);
//             log('✅ Coach $coachId added to favorites');

//             // ✅ حفظ في cache
//             _saveToCache(favoriteIds);

//             emit(FavoriteLoaded(favoriteIds: favoriteIds));
//           },
//           onError: (error) {
//             log('❌ Error adding favorite: ${error.message}');
//             emit(FavoriteError(error.message));

//             // Restore previous state
//             emit(currentState);
//           },
//         );
//       }
//     } catch (e) {
//       log('❌ Exception toggling favorite: $e');
//       emit(FavoriteError(e.toString()));

//       // Restore previous state
//       emit(currentState);
//     }
//   }

//   // ✅ فحص إذا المدرب في المفضلة
//   bool isFavorite(int coachId) {
//     final currentState = state;
//     if (currentState is FavoriteLoaded) {
//       return currentState.favoriteIds.contains(coachId);
//     }
//     return false;
//   }

//   // ✅ مسح المفضلات (للـ logout)
//   Future<void> clearFavorites() async {
//     try {
//       await CacheHelper.remove(key: 'favorite_coach_ids');
//       emit(FavoriteInitial());
//       log('✅ Favorites cleared');
//     } catch (e) {
//       log('❌ Error clearing favorites: $e');
//     }
//   }
// }
