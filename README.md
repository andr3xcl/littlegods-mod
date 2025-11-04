# LittleGods Mod Menu

[![Release](https://img.shields.io/badge/Release-v3.0.0-blue.svg)](https://github.com/andr3xcl/T6zm-Littlegods-Mod-Menu)
[![ZM](https://img.shields.io/badge/Game-Black%20Ops%202%20Zombies-red.svg)](https://github.com/andr3xcl/T6zm-Littlegods-Mod-Menu)

**Un menú completo de mods para Call of Duty Black Ops 2 Zombies con características avanzadas de personalización y control.**

## ✨ Características Principales

### 🎮 Sistema de Menú
- **Interfaz completamente personalizable** con múltiples estilos visuales
- **Animaciones de borde y fuente** configurables
- **Sistema de navegación intuitivo** con sonidos personalizables
- **Soporte multiidioma** (Español/English)
- **Posicionamiento flexible** (superior/inferior)

### 🏥 Sistema de Healthbars
- **Healthbar del Jugador**: Visualización de vida propia con colores dinámicos
- **Healthbar de Zombies**: Información de vida de zombies apuntados
- **Contador de Zombies**: Número total de zombies en el mapa
- **Personalización completa**: Colores, tamaños, posiciones y shaders

### 🌙 Modo Nocturno
- **Control de oscuridad** con múltiples niveles de intensidad
- **Filtros visuales** para diferentes efectos de noche
- **Sistema de niebla** activable/desactivable
- **Transiciones suaves** entre modos día/noche

### ⚔️ Sistema de Armas
- **Spawner completo de armas** para todos los mapas (Tránsito, Prisión, etc.)
- **Armas legendarias**: Ray Gun, Ray Gun MK-II, Death Machine
- **Armas especiales**: Ballistic Knife, Bowie Knife, etc.
- **Sistema de munición ilimitada** opcional

### ⭐ Perks y Powerups
- **Perks Ilimitados**: Desbloquea todos los perks sin límites
- **Spawner de Powerups**:
  - Max Ammo (Munición Máxima)
  - Insta Kill (Muerte Instantánea)
  - Carpenter (Reparación de barricadas)
  - Nuke (Eliminación masiva)
  - Y más...

### 🛡️ Modos de Juego Especiales
- **God Mode**: Invulnerabilidad completa
- **Control de Rondas**: Avanzar/retroceder rondas
- **Teleportación**: Viaje instantáneo a ubicaciones clave
- **UFO Mode**: Modo vuelo libre
- **Freeze Zombies**: Congelar movimiento de zombies

### 📊 Sistema de Estadísticas
- **Guardado automático** de récords personales por mapa
- **Sistema de ranking** con top de rondas
- **Estadísticas detalladas**: Kills, headshots, revives, downs
- **Sistema de archivos local** para persistencia

### 🎯 Sistema de Combate
- **Aimbot avanzado** con múltiples configuraciones
- **Auto-aim** y asistencia de puntería
- **Detección automática** de objetivos
- **Modos de fuego** personalizables

### 🔊 Sistema de Audio
- **Sonidos de menú personalizables**:
  - Apertura de menú
  - Cierre de menú
  - Navegación
  - Selección de opciones
- **Efectos de sonido** de armas reales del juego

### 👨‍💻 Modo Developer
- **Acceso protegido por contraseña**
- **Herramientas avanzadas** de desarrollo
- **Debugging tools** para modificaciones
- **Controles administrativos**

### 🎨 Personalización Visual
- **10+ estilos de menú** diferentes
- **Animaciones de borde** múltiples
- **Animaciones de fuente** configurables
- **Transparencia ajustable**
- **Colores y temas** personalizables

## 🗺️ Mapas Soportados

- **Tránsito** (Transit): Town, Farm, Bus Depot
- **Prisión** (Mob of the Dead): Cellblock, Docks, Showers, Rooftop
- **Origen** (Origins) - Próximamente
- **Todos los mapas** de Black Ops 2 Zombies

## 🚀 Instalación

### Requisitos
- Call of Duty Black Ops 2
- Plutonium Launcher o similar
- Archivos del mod

### Pasos de Instalación

1. **Descarga** el mod desde GitHub
2. **Extrae** los archivos `.gsc` en tu carpeta de scripts de Plutonium
3. **Inicia** el juego con Plutonium
4. **Une** una partida de Zombies
5. **Presiona** las teclas de activación del menú (consulta controles)

## 🎮 Controles

### Menú Principal
- **Abrir/Cerrar Menú**: `[{+actionslot 1}]` + `[{+melee}]` (por defecto)
- **Navegar**: `[{+attack}]` / `[{+speed_throw}]`
- **Seleccionar**: `[{+activate}]`
- **Volver**: `[{+melee}]`

### Developer Mode
- **Contraseña**: Contacta al desarrollador para obtener acceso

## 📁 Estructura de Archivos

```
littlegods-mod/
├── menu.gsc                 # Sistema principal de menú
├── funciones.gsc            # Funciones adicionales (God Mode, etc.)
├── weapon.gsc               # Sistema de armas
├── healthbarV2.gsc          # Healthbar del jugador
├── HealthBarZombie.gsc      # Healthbar de zombies
├── night_mode.gsc           # Modo nocturno
├── sqllocal.gsc             # Sistema de estadísticas
├── topround.gsc             # Ranking de rondas
├── playsound.gsc            # Sistema de sonidos
├── legacy_mods_performance.gsc # Displays de rendimiento
├── style_menu.gsc           # Estilos de menú
├── style_selector.gsc       # Estilos de selector
├── style_edge_animation.gsc # Animaciones de borde
├── style_font_position.gsc  # Posiciones de fuente
├── style_font_animation.gsc # Animaciones de fuente
├── style_transparecy.gsc    # Configuración de transparencia
└── README.md               # Este archivo
```

## 🔧 Configuración

### Personalización del Menú
```gsc
// En menu.gsc - Configuración de estilos
self.menu_style_index = 5; // 0-9 estilos disponibles
self.menu_position = 0;    // 0 = Superior, 1 = Inferior
self.langLEN = 0;          // 0 = Español, 1 = English
```

### Healthbar Configuration
```gsc
// En healthbarV2.gsc y HealthBarZombie.gsc
level.player_health_display.enabled = true;
level.player_health_display.color = (1, 1, 1); // RGB
level.player_health_display.fontscale = 1.1;
```

## 🛠️ Desarrollo

### Contribuir
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Compilación
Los archivos están escritos en GSC (Game Script Code) nativo de Call of Duty. No requieren compilación adicional.

## 📞 Soporte

### Discord
Únete a nuestro servidor de Discord: **dsc.gg/littlegods**

### Reportar Bugs
- Abre un issue en GitHub con detalles completos
- Incluye logs del juego y pasos para reproducir
- Especifica tu versión de Plutonium y mapa

## 👥 Créditos

**Desarrollado por:** LittleGods
- **Discord:** dsc.gg/littlegods
- **GitHub:** [@andr3xcl](https://github.com/andr3xcl)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## ⚠️ Descargo de Responsabilidad

Este mod está diseñado para uso personal y educativo. El uso en servidores públicos puede violar los términos de servicio. Úsalo bajo tu propio riesgo.

---

**¡Disfruta del mod y buena suerte sobreviviendo a las hordas zombie! 🧟‍♂️**
