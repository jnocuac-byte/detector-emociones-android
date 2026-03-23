import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EmotionApp());
}

class EmotionApp extends StatelessWidget {
  const EmotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector de Emociones',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmotionDetector(),
    );
  }
}

class EmotionDetector extends StatefulWidget {
  const EmotionDetector({super.key});

  @override
  State<EmotionDetector> createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  late Interpreter _interpreter;
  List<String> _labels = [];
  String _resultado = "Esperando imagen...";
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Usa la ruta exacta declarada en pubspec.yaml
      _interpreter = await Interpreter.fromAsset('assets/modelo_emociones.tflite');

      // Garantiza que la entrada sea [1, alto, ancho, canales]
      final inputShape = _interpreter.getInputTensor(0).shape;
      if (inputShape.length == 3) {
        _interpreter.resizeInputTensor(
          0,
          [1, inputShape[0], inputShape[1], inputShape[2]],
        );
      } else if (inputShape.length == 4 && inputShape[0] != 1) {
        _interpreter.resizeInputTensor(
          0,
          [1, inputShape[1], inputShape[2], inputShape[3]],
        );
      }
      _interpreter.allocateTensors();

      if (!mounted) return;

      final labelsContent =
          await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelsContent
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      setState(() => _isLoading = false);

      print("✅ Modelo cargado correctamente");
      print("📋 Etiquetas: $_labels");
    } catch (e) {
      print("❌ Error cargando modelo: $e");
      setState(() {
        _resultado = "Error cargando modelo";
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
      _resultado = "Procesando...";
    });

    await _classifyImage(File(image.path));
  }

  Future<void> _classifyImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        setState(() => _resultado = "Error al leer la imagen");
        return;
      }

      // 1. Redimensionar la imagen
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // 2. Crear el tensor de entrada con 4 dimensiones [1, 224, 224, 3]
      var input = List.generate(
        1,
        (b) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          }),
        ),
      );

      // 3. Preparar la salida
      var output = List.filled(1, List.filled(_labels.length, 0.0));

      // 4. Ejecutar inferencia
      _interpreter.run(input, output);

      // Obtener resultado
      List<double> probabilities = List<double>.from(output[0]);
      int maxIndex = 0;
      double maxProb = -1.0;

      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      setState(() {
        _resultado = "${_labels[maxIndex]}\n${(maxProb * 100).toStringAsFixed(1)}%";
      });
    } catch (e, stacktrace) {
      print("❌ Error en clasificación: $e");
      print(stacktrace);
      setState(() => _resultado = "Error al procesar");
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detector de Emociones'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_selectedImage != null)
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            else
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera),
              label: const Text('Tomar Foto'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Resultado:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _resultado,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}