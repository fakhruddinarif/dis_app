import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dis_app/blocs/searchFace/searchFace_bloc.dart';
import 'package:dis_app/blocs/searchFace/searchFace_state.dart';
import 'package:dis_app/blocs/searchFace/serachFace_event.dart';
import 'package:dis_app/pages/findme/DisplayPhotoScreen.dart';
import 'package:dis_app/pages/findme/ListFaceScreen.dart';
import 'package:dis_app/utils/constants/colors.dart';

class SearchFaceScreen extends StatefulWidget {
  @override
  _SearchFaceScreenState createState() => _SearchFaceScreenState();
}

class _SearchFaceScreenState extends State<SearchFaceScreen> {
  late SearchFaceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SearchFaceBloc>(context);
    _bloc.add(InitializeCameraEvent());
  }

  void _capturePhoto() {
    _bloc.add(CapturePhotoEvent());
  }

  void _searchMatchedPhotos(String userId) {
    _bloc.add(SearchMatchedPhotosEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Selfie',
          style: TextStyle(color: DisColors.white),
        ),
        backgroundColor: DisColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: DisColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<SearchFaceBloc, SearchFaceState>(
        listener: (context, state) async {
          if (state is SearchFacePhotoCaptured) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPhotoScreen(imagePath: state.imagePath),
              ),
            );

            if (result != null) {
              _searchMatchedPhotos('userIdHere');
            }
          } else if (state is SearchFaceMatchedPhotosLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListFaceScreen(
                  matchedPhotos: state.matchedPhotos,
                  imagePath: '',
                ),
              ),
            );
          } else if (state is SearchFaceNoMatchFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Tidak ada kecocokan ditemukan.")),
            );
          } else if (state is SearchFaceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is SearchFaceLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SearchFaceLoaded) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Transform(
                    transform: Matrix4.rotationY(0), // Nonaktifkan efek mirror
                    child: CameraPreview(state.controller),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: (MediaQuery.of(context).size.width - 150) / 2,
                  child: ElevatedButton(
                    onPressed: _capturePhoto,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: DisColors.white,
                      backgroundColor: DisColors.primary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Ambil Foto'),
                  ),
                ),
              ],
            );
          } else if (state is SearchFaceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _bloc.add(InitializeCameraEvent());
                    },
                    child: Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("Tidak ada kamera yang tersedia"));
          }
        },
      ),
    );
  }
}
