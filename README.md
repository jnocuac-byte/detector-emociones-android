# 😊 Detector de Emociones

Aplicación móvil para Android que detecta **4 emociones** en tiempo real usando **TensorFlow Lite** y un modelo entrenado con **Teachable Machine**.

---

## 📱 Capturas de pantalla
| Pantalla principal | Tomando foto | Resultado |
|--------------------|--------------|-----------|
| [captura 1] | [captura 2] | [captura 3] |

---

## 🎯 Emociones detectadas
| Emoción | Descripción |
|---------|-------------|
| 😊 **Alegre** | Felicidad, sonrisa |
| 😢 **Triste** | Tristeza, ceño fruncido |
| 😠 **Enojado** | Enojo, cejas juntas |
| 😲 **Sorprendido** | Sorpresa, ojos abiertos |

---

## 🧠 Modelo de Machine Learning
- **Plataforma**: [Teachable Machine](https://teachablemachine.withgoogle.com/)
- **Enlace del modelo**: [Ver modelo entrenado](https://teachablemachine.withgoogle.com/models/gbsV94_f5/)
- **Formato**: TensorFlow Lite (cuantificado)
- **Tamaño del modelo**: ~2 MB
- **Datos de entrenamiento**: 270 imágenes/clase (1080 total)
- **Épocas**: 100
- **Batch size**: 16

---

## 🛠️ Tecnologías utilizadas
| Tecnología | Descripción |
|------------|-------------|
| **Flutter** | Framework multiplataforma |
| **TensorFlow Lite** | Inferencia del modelo en dispositivo |
| **Teachable Machine** | Entrenamiento de visión computacional |
| **Camera** | Captura en tiempo real |
| **Image Picker** | Selección desde galería o cámara |

---

## 📦 Estructura del proyecto
```
detector-emociones/
├── assets/
│   ├── modelo_emociones.tflite   # Modelo entrenado
│   └── labels.txt                # Etiquetas
├── lib/
│   └── main.dart                 # Código principal
├── pubspec.yaml                  # Dependencias
└── README.md                     # Este archivo
```

---

## 🚀 Cómo instalar y ejecutar

### Opción 1: Descargar APK (recomendado)
1. Ve a **Releases** y descarga `app-release.apk`.
2. Transfiérelo al dispositivo Android.
3. Habilita instalación desde orígenes desconocidos.
4. Instala y abre la app.

### Opción 2: Compilar desde código fuente
**Requisitos:** Flutter SDK, Android Studio o VS Code.

```bash
git clone https://github.com/jnocuac-byte/detector-emociones.git
cd detector-emociones
flutter pub get
flutter run
```

---

## 📊 Resultados de entrenamiento
| Métrica | Valor |
|---------|-------|
| Precisión entrenamiento | > 95% |
| Precisión validación    | > 90% |
| Tamaño del modelo       | 656 KB (cuantificado) |
| Tiempo de inferencia    | < 100 ms/imagen |

---

## 🎓 Contexto académico
Proyecto del laboratorio de Inteligencia Artificial Afectiva:
- Entrenamiento y conversión a TFLite.
- Implementación móvil con Flutter.
- Evaluación de precisión, pérdida y matriz de confusión.

---

## 👨‍💻 Autor
- **Esteban Jno Cua**
- 📧 jnocuac@ucentral.edu.co
- 🔗 [GitHub](https://github.com/jnocuac-byte)

---

## 📄 Licencia
Uso académico. Todos los derechos reservados.

---

## 📋 Checklist de entrega
| Elemento | Estado |
|----------|--------|
| APK generado y funcionando | ✔️ |
| Modelo en Teachable Machine | ✔️ |
| Código en GitHub | ✔️ |
| README actualizado | ✔️ |
| Capturas de pantalla | ✔️ |

---

## 🧭 Próximos pasos sugeridos
1) Subir código y APK a GitHub (tags y release).  
2) Grabar video demo corto (≤60s) mostrando captura e inferencia.  
3) Incluir matriz de confusión y gráficos de pérdida/accuracy en el README.  
