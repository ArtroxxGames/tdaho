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

**Fase 3: Implementación de la Pantalla "Dashboard" (Completada)**

- [x] **Diseñar la Interfaz del Dashboard**: Se ha creado un layout visualmente atractivo y funcional.
- [x] **Crear Widgets Reutilizables**: Se han desarrollado widgets para el carrusel de acciones rápidas y las tarjetas de resumen.
- [x] **Carrusel de Acciones Rápidas**: Se ha implementado un carrusel funcional para acceder a las secciones principales.
- [x] **Integrar Datos de Muestra**: La pantalla del dashboard ahora muestra datos ficticios para simular el uso real.
- [ ] **Añadir Gráficos (Opcional)**: Integrar gráficos simples para visualizar datos financieros o de productividad.

## Plan de Implementación Actual

### Fase 4: Implementación de la Pantalla "Deudas" (Completada)

- [x] **Diseñar la Interfaz de Deudas**: Se ha creado un layout claro para mostrar la lista de deudas.
- [x] **Crear Widget de Tarjeta de Deuda**: Se ha desarrollado un widget para mostrar la información de cada deuda.
- [x] **Integrar Datos de Muestra**: La pantalla de deudas ahora muestra datos ficticios.
- [ ] **Implementar Formulario de "Añadir Deuda"**: Crear el formulario y la lógica para añadir nuevas deudas (actualmente es un TODO).

### Fase 5: Implementación de la Pantalla "Suscripciones" (Completada)

- [x] **Diseñar la Interfaz de Suscripciones**: Se ha creado un layout para mostrar la lista de suscripciones.
- [x] **Crear Widget de Tarjeta de Suscripción**: Se ha desarrollado un widget para mostrar la información de cada suscripción.
- [x] **Integrar Datos de Muestra**: La pantalla de suscripciones ahora muestra datos ficticios.
- [ ] **Implementar Formulario de "Añadir Suscripción"**: Crear el formulario y la lógica para añadir nuevas suscripciones (actualmente es un TODO).

### Fase 6: Implementación de la Pantalla "Tareas" (Completada)

- [x] **Diseñar la Interfaz de Tareas**: Se ha creado un layout para gestionar tareas con checkboxes.
- [x] **Crear Widget de Tarjeta de Tarea**: Se ha desarrollado un widget para cada tarea.
- [x] **Integrar Datos de Muestra**: La pantalla de tareas ahora muestra datos ficticios.
- [ ] **Implementar Formulario de "Añadir Tarea"**: Crear el formulario y la lógica para añadir nuevas tareas (actualmente es un TODO).

### Próximos Pasos

El siguiente paso es continuar con la implementación de las demás pantallas, comenzando por la de **"Notas"**. Esta sección permitirá a los usuarios crear y gestionar notas de texto.
