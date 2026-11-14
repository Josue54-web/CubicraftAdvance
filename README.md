# Cubicraft RPG — versión Game Boy Advance

Adaptación de **Cubicraft RPG** (el juego web de bloques, supervivencia y redstone) a una **ROM real de GBA** (`cubicraft.gba`), escrita en C sin librerías externas (solo registros de hardware). Se compila automáticamente en GitHub.

![titulo](docs/capturas/01_titulo.png)

## Cómo compilar en GitHub (sin instalar nada)

```bash
cd cubicraft-gba
git init
git add .
git commit -m "Cubicraft RPG para GBA"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/cubicraft-gba.git
git push -u origin main
```

1. Crea antes un repositorio **vacío** en GitHub llamado `cubicraft-gba` (sin README).
2. Al hacer `git push`, entra en la pestaña **Actions** → "Compilar ROM GBA".
3. Cuando termine (≈1-2 min), abre la ejecución y descarga el artefacto **cubicraft-gba** (contiene `cubicraft.gba`).
4. Para publicar la ROM en *Releases*: `git tag v1.0 && git push origin v1.0`.

### Compilar en tu PC (opcional)

1. Instala [devkitPro](https://devkitpro.org/wiki/Getting_Started) con el grupo `gba-dev` (Windows: instalador; Linux/Mac: `dkp-pacman -S gba-dev`).
2. En la carpeta del proyecto:

```bash
make          # genera cubicraft.gba
make clean    # limpia
```

En Windows usa la terminal **MSYS2 de devkitPro**. Si `make` dice que no encuentra devkitARM: `export DEVKITPRO=/opt/devkitpro DEVKITARM=/opt/devkitpro/devkitARM`.

Para jugar: mGBA, VisualBoyAdvance, o una flashcart (EZ-Flash, EverDrive GBA…). Guarda en **SRAM 32 KB** (2 ranuras).

## Controles

| Botón | Acción |
|---|---|
| Cruz | **Movimiento por casillas estilo Pokémon**: un toque gira en el sitio, mantener avanza casilla a casilla |
| **A** (mantener) | Minar, atacar, hablar con aldeanos, usar palancas/cofres/camas/mesas |
| **B** | Colocar bloque / usar objeto en mano (comer, beber, arco, balde, azada, semillas, caña, escudo, perla, ojo del End…) |
| **L / R** | Cambiar casilla de la barra rápida |
| **Start** | Menú: inventario, fabricar, mapa, logros, ayuda, guardar (2 ranuras), objetos (creativo) |
| **Select** | Mapa |

## Mejoras visuales

- **Texturas originales** de Cubicraft (suelos, bloques, objetos, jugador y mobs).
- **Ciclo día/noche con color**: amanecer rosado, atardecer naranja y noche azulada (tinte de paleta en tiempo real) + oscuridad con mezcla alfa de hardware (sombras suaves) y antorchas/lava/linternas que abren círculos de luz.
- **Menús renovados**: barras de título y selección, iconos de objetos en inventario, fabricación, comercio y objetos; recetas no disponibles en gris; contador de posición.
- **Tipografía** más gruesa y legible (DejaVu Sans Bold ajustada a 8×8).
- Golpe: tajo blanco delante del jugador (en vez del antiguo "+").

## Qué se conservó del juego original

- **4 dimensiones**: superficie (128×128), cuevas, Nether (fortaleza de ladrillo, ghasts, blazes, piglins) y el End (Dragón con barra de vida).
- **Mundo procedural** por semilla: océanos (algas, corales), playas, llanuras, bosques, desiertos (cactus), nieve (pinos), jungla, colinas con **puertas a las cuevas**, **3 aldeas** con casas, pozo, granjas, cofres, aldeanos y gatos.
- **Supervivencia / Creativo / Hardcore**, vida, hambre, XP y niveles, ciclo día/noche (5 min), luz de antorchas/lámparas, lava, armaduras, escudo.
- **~115 objetos** y **~70 recetas** (herramientas de madera a netherita, armas, armaduras, comida, camas, arco…), minado por niveles de pico.
- **Redstone**: cable con atenuación, antorcha inversora, bloque, palanca, botón, placa, observador, repetidor (retardo), comparador, pistón y pistón pegajoso, lámpara, dispensador, tolva, TNT.
- **Granja**: azada, semillas, trigo/zanahoria, aspersor, cosechadora.
- **Portal del Nether** (anillo 3×3 de obsidiana, agua sobre lava = obsidiana), **portal del End** (marcos + Ojos del End en la fortaleza de las cuevas).
- Mobs: vaca, cerdo, oveja, gallina (cría), zombi, creeper, esqueleto, enderman, blaze, ghast, piglin, aldeano (comercio por profesión), gato (domable), calamar, dragón.
- Encantamientos (mesa), pociones (soporte), pesca, comercio, 18 logros, mapa.

## Cómo se resolvieron los límites de la GBA

| Límite | Solución |
|---|---|
| Texturas | Se usan las **texturas originales del juego** (suelos, bloques, iconos de objetos, jugador y mobs), extraídas del HTML a `assets/` y cuantizadas por `tools/gen_art.py` a una **paleta global de 240 colores** (+15 del HUD). Ghast, dragón, proyectiles y cultivos en crecimiento siguen siendo dibujados por código |
| 192 metatiles máx. | Estados (encendido/apagado) en slots alternativos; direcciones con *flips* de hardware + variante transpuesta |
| Mundo enorme | 4 mapas con ruido de valor entero (sin `float`), mapa en toro de 16×16 casillas que solo reescribe columnas/filas nuevas al caminar |
| Guardado en 32 KB | Se guarda la **semilla + solo las casillas modificadas** (y cofres, inventario…) → ~3000 ediciones por ranura |
| Sin luz dinámica | Capa de **oscuridad punteada** (dithering) por casilla; las fuentes de luz abren huecos |
| 128 sprites | Jugador, ≤36 mobs, proyectiles y la barra rápida; iconos del inventario se suben a VRAM solo cuando cambian |
| Sin ratón/táctil/multijugador/WebGL | Eliminados (mapa y teletransporte con Select / perla en línea recta); texto sin acentos por la fuente 8×8 |

## Qué NO se portó (por hardware)

Multijugador en red y pantalla dividida, motor 3D/2.5D WebGL y editor de caras, modo táctil/primera persona, mundo de pruebas con código secreto, Wither/Warden/lobos, mundos de 512×512 por chunks, 3 capas de construcción, 5 ranuras (hay 2), pociones largas/arrojadizas (hay 7 efectos base) y la animación de las alturas del terreno.

## Estructura

```
Makefile               devkitARM -> cubicraft.gba
.github/workflows/     compilación automática (contenedor devkitpro/devkitarm)
source/                código del juego (C)
  gba.h  data.*  gfx.*  art.*(generado)  world.c  player.c  entity.c  redstone.c  ui.c  save.c  main.c  font.h
preview/               vista previa en PC (emula el PPU de la GBA): host.c, test.c, fuzz.c, run.sh
tools/gen_font.py      genera source/font.h
tools/gen_art.py       assets/ (PNG originales) -> source/art.c (paleta + gráficos). Ejecutar: python3 tools/gen_art.py
assets/                texturas originales extraídas de Cubicraft (tex, ico, spr, comp)
docs/capturas/         capturas del juego
```

`preview/run.sh` (gcc + Pillow) regenera las capturas con **el mismo código** del juego. `preview/test.c` comprueba minado, crafteo, portales, redstone, cultivos, comercio, guardado, dragón y encantamientos.

## Capturas

| | |
|---|---|
| ![](docs/capturas/03_aldea.png) | ![](docs/capturas/05_noche.png) |
| ![](docs/capturas/08_nether.png) | ![](docs/capturas/10b_dragon.png) |
| ![](docs/capturas/17_redstone.png) | ![](docs/capturas/12_fabricar.png) |
