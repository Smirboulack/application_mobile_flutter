import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sevenapplication/core/view_model/sector_view_model.dart';

class SectorListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sectors'),
      ),
      body: Consumer<SectorViewModel>(
        builder: (context, sectorViewModel, _) {
          if (sectorViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: sectorViewModel.sectors.length,
              itemBuilder: (context, index) {
                final sector = sectorViewModel.sectors[index];

                return ListTile(
                  title: Text(sector.name),
                  subtitle: Text(sector.objectId),
                );
              },
            );
          }
        },
      ),
    );
  }
}