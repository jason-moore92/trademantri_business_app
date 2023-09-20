// import 'package:flutter/material.dart';
// import 'package:trapp/src/elements/keicy_progress_dialog.dart';
// import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';
// import 'package:trapp/src/providers/index.dart';

// class FavoriteIconWidget extends StatefulWidget {
//   final double size;
//   final String? id;
//   final String? storeId;
//   final String? category;

//   FavoriteIconWidget({
//     @required this.category,
//     @required this.id,
//     @required this.storeId,
//     this.size = 20,
//   });

//   @override
//   _FavoriteIconWidgetState createState() => _FavoriteIconWidgetState();
// }

// class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
//   AuthProvider? _authProvider;
//   FavoriteProvider? _favoriteProvider;

//   @override
//   void initState() {
//     super.initState();

//     _authProvider = AuthProvider.of(context);
//     _favoriteProvider = FavoriteProvider.of(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isFavorite = false;
//     if (_favoriteProvider!.favoriteState.favoriteData!.isNotEmpty &&
//         _favoriteProvider!.favoriteState.favoriteData![widget.category] != null &&
//         _favoriteProvider!.favoriteState.favoriteData![widget.category].isNotEmpty) {
//       for (var i = 0; i < _favoriteProvider!.favoriteState.favoriteData![widget.category].length; i++) {
//         if (_favoriteProvider!.favoriteState.favoriteData![widget.category][i]["userId"] == _authProvider!.authState.userModel!.id &&
//             _favoriteProvider!.favoriteState.favoriteData![widget.category][i]["id"] == widget.id &&
//             (widget.category == "stores" || _favoriteProvider!.favoriteState.favoriteData![widget.category][i]["storeId"] == widget.storeId)) {
//           isFavorite = true;
//           break;
//         }
//       }
//     }

//     return GestureDetector(
//       onTap: () async {
//         if (_favoriteProvider!.favoriteState.progressState == 1) return;
//         _favoriteProvider!.setFavoriteState(_favoriteProvider!.favoriteState.update(progressState: 1), isNotifiable: false);

//         await _favoriteProvider!.setFavoriteData(
//           userId: _authProvider!.authState.userModel!.id,
//           id: widget.id,
//           storeId: widget.storeId,
//           category: widget.category,
//           isFavorite: !isFavorite,
//         );
//         setState(() {});
//       },
//       child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border_outlined, size: widget.size, color: Colors.red),
//     );
//   }
// }
