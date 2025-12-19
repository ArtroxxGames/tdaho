# Blueprint: TDAH Organizer

## Visión General

**TDAH Organizer** es una aplicación integral diseñada en Flutter para ayudar a las personas con TDAH a gestionar sus finanzas, productividad y organización personal. La aplicación implementará un diseño moderno y funcional, con un tema oscuro, y se centrará en características amigables para el TDAH, como recordatorios visuales, listas cortas y seguimiento del progreso.

## Diseño y Estilo Implementados

- **Tema Principal:** Oscuro (Dark Mode).
- **Paleta de Colores:** Se utilizó la paleta definida en `documentacion.md`, incluyendo colores de fondo, texto y acentos.
- **Tipografía:** Se configuró `google_fonts` para usar las fuentes del sistema y monoespaciadas según las especificaciones.
- **Componentes Visuales:** Se implementó un estilo visual coherente con `Material 3`, utilizando los colores y la tipografía definidos.
- **Internacionalización (i18n):** Se ha configurado la aplicación para soportar múltiples idiomas, comenzando con el español. Se utiliza el paquete `intl` y los archivos `.arb` para la gestión de traducciones.

**Fase 1: Configuración del Entorno y Tema Visual (Completada)**

- [x] **Crear `blueprint.md`**: Documentar el plan de desarrollo y el estado del proyecto.
- [x] **Añadir Dependencias**: Integrar `provider` para la gestión del estado del tema y `google_fonts` para la tipografía personalizada.
- [x] **Definir Paleta de Colores**: Crear un archivo `lib/theme/app_colors.dart`.
- [x] **Configurar Tema de la Aplicación**: Crear un archivo `lib/theme/app_theme.dart`.
- [x] **Implementar Proveedor de Tema**: Modificar `lib/main.dart` para usar `ChangeNotifierProvider`.
- [x] **Estructura Inicial**: Crear la estructura básica de la aplicación en `lib/main.dart` con una pantalla de bienvenida.

**Fase 2: Navegación y Layout Principal (Completada)**

- [x] **Crear Estructura de Carpetas**: Organizar el proyecto con carpetas `screens` y `widgets`.
- [x] **Crear Archivos de Pantalla**: Generar los archivos para cada sección principal de la app (Dashboard, Deudas, Tareas, etc.).
- [x] **Implementar el Menú Lateral (`Drawer`)**: Diseñar el widget de navegación con todos los ítems y sus iconos correspondientes.
- [x] **Integrar el Layout**: Reemplazar la pantalla de bienvenida en `main.dart` con el nuevo layout, permitiendo la navegación entre las diferentes pantallas.
- [x] **Internacionalización (i18n)**: Configurar la app para soportar múltiples idiomas (español).

**Fase 3: Maquetación de Pantallas y Funcionalidad Básica (Completada)**

- [x] **Dashboard**: Interfaz atractiva, carrusel de acciones rápidas y datos de muestra.
- [x] **Deudas**: Interfaz clara, widget de tarjeta de deuda y formulario de creación.
- [x] **Suscripciones**: Interfaz clara, widget de tarjeta de suscripción y formulario de creación.
- [x] **Tareas**: Interfaz de gestión de tareas con checkboxes y formulario de creación.
- [x] **Notas**: Interfaz de lista de notas y formulario de creación.
- [x] **Enfoque**: Temporizador Pomodoro funcional.

## Plan de Implementación Actual

### Fase 4: Refactorización de la Gestión de Estado con Provider (En Progreso)

El estado de la aplicación se gestiona actualmente de forma local en cada pantalla, lo que impide la persistencia y el intercambio de datos. Esta fase se centra en centralizar la gestión del estado utilizando el paquete `provider`.

- [ ] **Crear Modelos de Datos**: Mover las clases de datos a una nueva carpeta `lib/models`.
- [ ] **Crear Proveedores (`ChangeNotifier`)**: Crear un `ChangeNotifier` para cada modelo de datos en una nueva carpeta `lib/providers`.
- [ ] **Integrar `MultiProvider`**: En `main.dart`, envolver la aplicación con `MultiProvider` para hacer accesibles los proveedores en todo el árbol de widgets.
- [ ] **Refactorizar las Pantallas**: Actualizar cada pantalla para consumir los datos desde su `provider` correspondiente en lugar de gestionar un estado local.
- [ ] **Refactorizar los Formularios**: Conectar los formularios de creación para que utilicen los métodos de los `providers` para añadir nuevos datos.

### Próximos Pasos

Una vez que la gestión del estado esté centralizada, los siguientes pasos serán:

1.  **Persistencia de Datos**: Integrar una solución de almacenamiento local (como `shared_preferences` o una base de datos como `Hive` o `Isar`) para que los datos persistan entre sesiones.
2.  **Lógica de Negocio Avanzada**: Implementar funcionalidades más complejas, como la edición y eliminación de elementos, notificaciones, y cálculos en el dashboard.
3.  **Añadir Gráficos (Opcional)**: Integrar gráficos simples para visualizar datos financieros o de productividad en el dashboard.
