import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/camera.dart'; // Necesario para la cámara

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Arrancamos el juego
  runApp(GameWidget(game: GussunGame()));
}

class GussunGame extends FlameGame {
  // --- CONFIGURACIÓN RETRO ---
  // Resolución virtual de 320 píxeles de ancho (estilo SNES/Genesis)
  static const double resolucionAncho = 320.0;
  static const double tamanoBloque = 32.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. CONFIGURAR CÁMARA
    // Esto hace que el juego se vea pixelado a propósito (Zoom in)
    camera = CameraComponent.withFixedResolution(
      width: resolucionAncho,
      height: resolucionAncho * (size.y / size.x), 
      world: world,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    // 2. AGREGAR AL PERSONAJE
    // Lo ponemos en la posición X=50, Y=100
    world.add(GussunPlayer(
      posicion: Vector2(50, 100), 
    ));
    
    // (Opcional) Un suelo simple para referencia visual
    world.add(RectangleComponent(
      position: Vector2(0, 200),
      size: Vector2(resolucionAncho, 10),
      paint: Paint()..color = Colors.brown,
    ));
  }
}

// --- CLASE DEL PERSONAJE ---
class GussunPlayer extends SpriteComponent with HasGameRef<GussunGame> {
  
  GussunPlayer({required Vector2 posicion}) 
      : super(position: posicion, size: Vector2.all(32.0)); // 32x32 es el tamaño estándar

  @override
  Future<void> onLoad() async {
    // IMPORTANTE: Aquí cargamos el archivo 'personaje.png'
    // Si tu archivo se llama diferente, cambia el nombre aquí.
    sprite = await gameRef.loadSprite('assets/personaje.png'); 
    
    // TRUCO DE CALIDAD:
    // Esto evita que Flutter intente "suavizar" la imagen.
    // Queremos que se vean los píxeles duros.
    paint.filterQuality = FilterQuality.none;
  }
}