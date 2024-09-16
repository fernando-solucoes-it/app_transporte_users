import 'package:flutter/material.dart';
import '../models/prediction_model.dart';

class PredictionPlaceUI extends StatelessWidget {
  final PredictionModel predictedPlaceData;

  const PredictionPlaceUI({required this.predictedPlaceData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(predictedPlaceData.main_text ?? ''),
      subtitle: Text(predictedPlaceData.secondary_text ?? ''),
      // Adicione outros widgets e estilos conforme necessário
    );
  }
}
