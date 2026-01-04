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

### Fase 4: Refactorización de la Gestión de Estado con Provider (✅ Completada)

- [x] **Crear Modelos de Datos**: Mover las clases de datos a una nueva carpeta `lib/models`.
- [x] **Crear Proveedores (`ChangeNotifier`)**: Crear un `ChangeNotifier` para cada modelo de datos en una nueva carpeta `lib/providers`.
- [x] **Integrar `MultiProvider`**: En `main.dart`, envolver la aplicación con `MultiProvider` para hacer accesibles los proveedores en todo el árbol de widgets.
- [x] **Refactorizar las Pantallas**: Actualizar cada pantalla para consumir los datos desde su `provider` correspondiente en lugar de gestionar un estado local.
- [x] **Refactorizar los Formularios**: Conectar los formularios de creación para que utilicen los métodos de los `providers` para añadir nuevos datos.

### Fase 5: Sistema de Moneda y Configuración (✅ Completada)

- [x] **SettingsProvider**: Sistema de gestión de moneda configurable (PYG por defecto)
- [x] **CurrencyFormatter**: Utilidad para formatear monedas en toda la app
- [x] **Pantalla de Configuración**: Completa con estadísticas, tipo de cambio, y zona de peligro
- [x] **Persistencia de Configuración**: Implementada con `shared_preferences`

### Fase 6: Funcionalidades Financieras Core (✅ Completada)

- [x] **Tarjetas de Crédito**: Modelo, Provider y Pantalla completa
  - [x] Modelo `CreditCard` con todos los campos necesarios
  - [x] Provider con cálculos de resumen mensual
  - [x] Pantalla principal con cards expandibles
  - [x] Formulario crear/editar tarjeta
  - [x] Integración con ExpenseProvider para gastos asociados
  - [x] Cálculo de cuotas y disponible
- [x] **Pagos Atrasados**: Modelo, Provider y Pantalla completa
  - [x] Modelo `OverduePayment` con cálculo de días de atraso
  - [x] Provider con detección automática desde deudas
  - [x] Pantalla principal con cards de resumen
  - [x] Formulario registrar/editar atraso
  - [x] Resumen por concepto
  - [x] Estado "Todo al día" cuando no hay atrasos
- [x] **Mejoras al Dashboard**: Cards de resumen completos según documentación
  - [x] Header con saludo y fecha
  - [x] 4 Cards de resumen (Cuotas, Suscripciones, Pagos Atrasados, Gastos de Hoy)
  - [x] Card Total Gastos Fijos Mensuales con gradiente
  - [x] Sección Productividad (Tareas y Educación)
  - [x] Acciones Rápidas (grid responsive)
  - [x] Tip del Día con mensajes motivacionales TDAH

### Fase 7: Persistencia de Datos (✅ Completada)

- [x] **StorageService**: Servicio centralizado para gestión de Hive
- [x] **Migración de Providers**: Todos los providers migrados a usar Hive:
  - [x] DebtProvider
  - [x] SubscriptionProvider
  - [x] ExpenseProvider
  - [x] CreditCardProvider
  - [x] OverduePaymentProvider
  - [x] TaskProvider
  - [x] NoteProvider
- [x] **Serialización de Modelos**: Todos los modelos tienen toJson/fromJson
- [x] **Inicialización**: Hive configurado en main.dart
- [x] **Actualización de Pantallas**: Todas las pantallas usan métodos async

### Fase 8: Cursos & Educación (✅ Completada)

- [x] **Modelo Course**: Modelo completo con todos los campos y serialización
- [x] **CourseProvider**: Provider con persistencia Hive y métodos completos
- [x] **Pantalla Courses**: Pantalla completa con:
  - [x] Toggle vista Lista/Calendario
  - [x] Sección "Cursos para Hoy"
  - [x] Cards de resumen (activos, pausados, para hoy, progreso promedio)
  - [x] Vista Lista con grid responsive
  - [x] Vista Calendario semanal (7 días)
  - [x] Filtros (Todos/Activos/Pausados)
  - [x] Formulario crear/editar completo
- [x] **Integración**: Agregado a Dashboard y navegación principal

### Próximos Pasos

1.  **Tareas Kanban**: Mejorar con drag & drop y vista Kanban completa
2.  **Vista Tabla Excel de Deudas**: Completar navegación de años y estados visuales
3.  **Sistema de Logs**: Implementar módulo completo de logging
4.  **Backup y Exportación**: Funcionalidad de exportar/importar datos
