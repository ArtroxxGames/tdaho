# 📱 PROMPT DETALLADO: TDAH Organizer - Recreación en Flutter

## 🎯 DESCRIPCIÓN GENERAL

**TDAH Organizer** es una aplicación web diseñada específicamente para ayudar a personas con TDAH a organizar todos los aspectos de su vida financiera y productividad personal. La aplicación está construida con Next.js 16, TypeScript, Tailwind CSS y Supabase como backend.

### Propósito Principal
- Gestión financiera completa (deudas, suscripciones, gastos, tarjetas)
- Sistema de productividad con tablero Kanban
- Seguimiento educativo (cursos y progreso)
- Control de pagos atrasados
- Sistema de logs de actividad

---

## 🏗️ ARQUITECTURA Y TECNOLOGÍAS

### Stack Original
- **Frontend**: Next.js 16 (App Router), React 19, TypeScript
- **Estilos**: Tailwind CSS 4
- **Backend**: Supabase (PostgreSQL + Auth)
- **Estado Global**: Zustand
- **Drag & Drop**: @dnd-kit
- **Iconos**: Lucide React
- **PWA**: Service Worker, Manifest

### Arquitectura de Datos
- **Patrón Repository**: Separación de acceso a datos
- **Services**: Lógica de negocio
- **Row Level Security (RLS)**: Cada usuario solo ve sus datos
- **API Routes**: Next.js API Routes como backend

---

## 🎨 DISEÑO Y UI/UX

### Sistema de Diseño

#### Colores (Tema Oscuro)
```css
--bg-primary: #0f0f15
--bg-secondary: #16161f
--bg-tertiary: #1e1e2a
--bg-card: #1a1a24
--border-color: #2d2d3d
--text-primary: #f5f5f8
--text-secondary: #b0b0c0
--text-muted: #707080
--accent-primary: #6366f1 (Indigo)
--accent-secondary: #8b5cf6 (Purple)
--gradient-start: #6366f1
--gradient-end: #a855f7
```

#### Componentes Visuales
- **Glassmorphism**: Cards con efecto de vidrio (backdrop-filter blur)
- **Gradientes**: Botones y elementos destacados
- **Animaciones**: fadeIn, slideUp, pulse-glow
- **Responsive**: Mobile-first, breakpoints en 640px y 768px
- **Touch-friendly**: Botones mínimo 44px de altura en móvil

#### Tipografía
- Fuente: System UI (San Francisco, Segoe UI, etc.)
- Monospace: Para números (SF Mono, Fira Code)

---

## 📱 ESTRUCTURA DE NAVEGACIÓN

### Sidebar (Menú Lateral)

**Logo y Branding:**
- Logo: Icono Brain con gradiente
- Título: "TDAHOrganizer"
- Subtítulo: "Tu vida, organizada"

**Información de Usuario:**
- Avatar/Icono de usuario
- Nombre (de metadata o email)
- Email del usuario

**Items del Menú:**
1. **Dashboard** (`/`) - Icono: LayoutDashboard
2. **Cuotas & Deudas** (`/deudas`) - Icono: CreditCard
3. **Suscripciones** (`/suscripciones`) - Icono: Receipt
4. **Pagos Atrasados** (`/atrasados`) - Icono: AlertTriangle
5. **Gastos Diarios** (`/gastos`) - Icono: Wallet
6. **Tarjetas de Crédito** (`/tarjetas`) - Icono: Landmark
7. **Cursos & Educación** (`/cursos`) - Icono: GraduationCap
8. **Tareas Kanban** (`/tareas`) - Icono: CheckSquare
9. **Logs** (`/logs`) - Icono: FileText
10. **Configuración** (`/configuracion`) - Icono: Settings

**Footer del Sidebar:**
- Botón "Cerrar Sesión" (con confirmación)
- Mensaje: "Hecho con 💜 para mentes brillantes"

**Comportamiento Responsive:**
- Desktop: Sidebar fijo a la izquierda (64px de ancho, 256px total)
- Mobile: Sidebar oculto por defecto, botón hamburguesa en top-left
- Overlay oscuro cuando sidebar está abierto en móvil

---

## 🏠 PANTALLAS Y FUNCIONALIDADES

### 1. AUTENTICACIÓN

#### Login (`/login`)
**Campos:**
- Email (con icono Mail)
- Contraseña (con icono Lock, toggle mostrar/ocultar)
- Botón "Iniciar Sesión"
- Link a registro

**Validaciones:**
- Email válido requerido
- Contraseña requerida
- Mensajes de error personalizados

**Logging:**
- Registra intentos de login (exitosos y fallidos)

#### Registro (`/registro`)
**Campos:**
- Nombre (opcional)
- Email (requerido)
- Contraseña (mínimo 6 caracteres)
- Confirmar Contraseña
- Botón "Crear Cuenta"

**Validaciones:**
- Contraseñas deben coincidir
- Mínimo 6 caracteres
- Email único

**Post-registro:**
- Mensaje de éxito
- Instrucciones para confirmar email
- Link a login

---

### 2. DASHBOARD (`/`)

**Header:**
- Saludo: "¡Hola! 👋"
- Fecha actual formateada
- Mes y año actual

**Cards de Resumen (Grid 2x2 en móvil, 4 columnas en desktop):**
1. **Cuotas Mensuales**
   - Total en Gs
   - Cantidad de deudas activas
   - Color: Azul

2. **Suscripciones**
   - Total en Gs (con conversión USD)
   - Desglose USD + GS
   - Color: Púrpura

3. **Pagos Atrasados**
   - Total acumulado
   - Cantidad de pagos pendientes
   - Color: Rojo (si hay) o Verde (si está al día)

4. **Gastos de Hoy**
   - Total del día
   - Fecha formateada
   - Color: Ámbar

**Card Total Gastos Fijos Mensuales:**
- Suma de cuotas + suscripciones
- Desglose por tipo
- Gradiente destacado

**Sección Productividad:**
- **Tareas Kanban**: Contador por estado (Pendientes, En Progreso, Completadas)
- **Educación**: Cantidad de cursos activos

**Acciones Rápidas (Grid 2x2 en móvil, 4 columnas en desktop):**
- + Gasto
- + Tarea
- + Deuda
- + Suscripción

**Tip del Día:**
- Mensaje motivacional para usuarios TDAH

---

### 3. CUOTAS & DEUDAS (`/deudas`)

**Header:**
- Título con icono
- Toggle de vista: "Tarjetas" / "Tabla"
- Botón "Nueva Deuda"

**Alerta de Cuotas Pendientes:**
- Muestra si hay cuotas por pagar este mes
- Lista de deudas con cuotas pendientes

**Cards de Resumen:**
- Cuota Mensual Total
- Deuda Total Pendiente
- Total de Deudas

**Vista Tarjetas:**
- Grid responsive (1 col móvil, 2 tablet, 3 desktop)
- Cada card muestra:
  - Nombre de la deuda
  - Día de vencimiento (con alerta si vence este mes)
  - Cuota mensual
  - Monto total
  - Progreso (X/Y cuotas)
  - Barra de progreso
  - Botón "Marcar Cuota Pagada" (si hay pendientes)
  - Badge "¡Deuda Liquidada!" si está completa
  - Botones Editar/Eliminar

**Vista Tabla (Tipo Excel):**
- Tabla con:
  - Columna fija izquierda: Nombre de deuda + progreso
  - Columna: Monto cuota
  - 12 columnas: Meses del año (Ene, Feb, Mar, etc.)
- Navegación de años (anterior/siguiente)
- Estados visuales:
  - ✓ Verde: Pagado
  - ● Ámbar: Pendiente
  - ! Rojo: Atrasado
  - - Gris: Futuro
  - —: No aplica
- Leyenda de estados

**Modal Crear/Editar Deuda:**
- Nombre de la deuda *
- Cuota Mensual (Gs) *
- Total de Cuotas *
- Monto Total (calculado automáticamente)
- Cuotas Pagadas
- Día Vencimiento * (1-28)
- Fecha de Inicio *
- Notas (opcional)

**Funcionalidades:**
- Crear deuda
- Editar deuda
- Eliminar deuda (con confirmación)
- Marcar cuota como pagada (incrementa cuotasPagadas)

---

### 4. SUSCRIPCIONES (`/suscripciones`)

**Header:**
- Título con icono
- Botón "Nueva Suscripción"

**Cards de Resumen:**
- Total USD (con cantidad)
- Total GS (con cantidad)
- Total Mensual en Gs (con conversión)
- Tipo de cambio actual

**Filtros:**
- Todas / Activas / Pausadas

**Grid de Suscripciones:**
- Cada card muestra:
  - Icono de categoría
  - Nombre del servicio
  - Día de renovación
  - Monto (en moneda original)
  - Equivalente en Gs (si es USD)
  - Botón Activar/Pausar
  - Botones Editar/Eliminar
  - Badge "Pausada" si está inactiva

**Categorías Disponibles:**
- Streaming (Tv icon)
- Música (Music icon)
- Cloud (Cloud icon)
- Gaming (Gamepad2 icon)
- Educación (BookOpen icon)
- Software (Settings icon)
- Otros (Globe icon)

**Modal Crear/Editar Suscripción:**
- Nombre del servicio *
- Monto *
- Moneda * (USD/GS)
- Categoría *
- Día renovación * (1-28)
- Notas (opcional)

**Funcionalidades:**
- Crear suscripción
- Editar suscripción
- Eliminar suscripción (con confirmación)
- Activar/Pausar suscripción (toggle)

---

### 5. GASTOS DIARIOS (`/gastos`)

**Header:**
- Título con icono
- Botón "Nuevo Gasto"

**Cards de Resumen:**
- Hoy (total del día)
- Semana (total de la semana)
- Mes (total del mes)
- Filtrado (total según filtros activos)

**Filtros:**
- Periodo: Todo / Hoy / Semana / Mes
- Categoría: Todas / [Lista de categorías]

**Lista de Gastos (Agrupados por Fecha):**
- Cada grupo de fecha muestra:
  - Fecha formateada ("Hoy", "Ayer", o fecha completa)
  - Día de la semana
  - Cantidad de gastos
  - Total del día
- Cada gasto muestra:
  - Icono de categoría
  - Descripción
  - Categoría
  - Método de pago (Tarjeta con nombre + cuotas si aplica, o Efectivo)
  - Monto (en moneda original)
  - Equivalente en Gs (si es USD)
  - Monto por cuota (si es en cuotas)
  - Botones Editar/Eliminar

**Categorías de Gastos:**
- Alimentación (Utensils, naranja)
- Transporte (Car, azul)
- Entretenimiento (Gamepad2, púrpura)
- Café/Snacks (Coffee, ámbar)
- Compras (ShoppingCart, rosa)
- Salud (Heart, rojo)
- Educación (BookOpen, cyan)
- Hogar (Home, verde)
- Otros (MoreHorizontal, gris)

**Modal Crear/Editar Gasto:**
- Descripción *
- Monto *
- Moneda * (GS/USD)
- Categoría *
- Fecha *
- Método de Pago:
  - Botón Efectivo / Tarjeta
  - Si es Tarjeta:
    - Select de tarjetas activas
    - Checkbox "Pago en cuotas"
    - Si es cuotas:
      - Select número de cuotas (2, 3, 6, 9, 12, 18, 24, 36, 48)
      - Cálculo de cuota mensual
- Notas (opcional)

**Funcionalidades:**
- Crear gasto
- Editar gasto
- Eliminar gasto (con confirmación)
- Filtrado por fecha y categoría
- Cálculo automático de cuota actual para gastos en cuotas

---

### 6. TARJETAS DE CRÉDITO (`/tarjetas`)

**Header:**
- Título con icono
- Botón "Nueva Tarjeta"
- Selector de Mes/Año (navegación anterior/siguiente)

**Cards de Resumen:**
- Total a Pagar (suma de todas las tarjetas)
- Total Disponible (suma de límites - gastos)
- Límite Total (suma de límites de tarjetas activas)

**Grid de Tarjetas:**
- Cada card muestra:
  - Icono de tarjeta
  - Nombre + últimos 4 dígitos
  - Banco (si está configurado)
  - Día de cierre
  - Día de vencimiento
  - Botones Activar/Desactivar, Editar, Eliminar
  - **Resumen del Mes Seleccionado:**
    - Total a pagar
    - Desglose: Contado / Cuotas
    - Disponible (si tiene límite configurado)
    - Barra de progreso de uso
    - Botón expandir/colapsar lista de gastos
    - Lista de gastos del mes (expandible)

**Modal Crear/Editar Tarjeta:**
- Nombre de la tarjeta *
- Banco (opcional)
- Últimos 4 dígitos (opcional, máximo 4)
- Límite de crédito (Gs, opcional)
- Día de cierre * (1-28)
- Día de vencimiento * (1-28)
- Notas (opcional)

**Funcionalidades:**
- Crear tarjeta
- Editar tarjeta
- Eliminar tarjeta (con advertencia sobre gastos asociados)
- Activar/Desactivar tarjeta
- Cálculo de resumen mensual por tarjeta
- Agrupación de gastos por mes según día de cierre
- Cálculo de cuota actual para gastos en cuotas

---

### 7. CURSOS & EDUCACIÓN (`/cursos`)

**Header:**
- Título con icono
- Toggle de vista: "Lista" / "Calendario"
- Botón "Nuevo Curso"

**Sección "Cursos para Hoy":**
- Muestra cursos activos asignados al día actual
- Card por curso con:
  - Nombre
  - Plataforma
  - Hora de inicio (si tiene)
  - Duración (si tiene)
  - Progreso %

**Cards de Resumen:**
- Cursos Activos
- Pausados
- Para Hoy
- Progreso Promedio

**Filtros (solo en vista Lista):**
- Todos / Activos / Pausados

**Vista Lista:**
- Grid responsive (1 móvil, 2 tablet, 3 desktop)
- Cada card muestra:
  - Nombre del curso
  - Plataforma
  - Barra de progreso
  - Días asignados (mini badges L, M, M, J, V, S, D)
  - Hora de inicio y duración (si tiene)
  - Link externo (si tiene URL)
  - Notas (si tiene)
  - Botones Activar/Pausar, Editar, Eliminar

**Vista Calendario:**
- Grid de 7 columnas (Lunes a Domingo)
- Cada día muestra:
  - Header con nombre del día (destacado si es hoy)
  - Lista de cursos asignados a ese día
  - Cada curso muestra nombre, plataforma, hora, progreso

**Plataformas Disponibles:**
- Udemy, Coursera, Platzi, Domestika, LinkedIn Learning, YouTube, Skillshare, edX, FreeCodeCamp, Otro

**Modal Crear/Editar Curso:**
- Nombre del curso *
- Plataforma * (select)
- URL del curso (opcional)
- Progreso (%) (0-100)
- Días de estudio (checkboxes L, M, M, J, V, S, D)
- Hora de inicio (opcional, time picker)
- Duración en minutos (opcional)
- Notas (opcional)

**Funcionalidades:**
- Crear curso
- Editar curso
- Eliminar curso (con confirmación)
- Activar/Pausar curso
- Asignar días de estudio
- Actualizar progreso

**Tip TDAH:**
- Recomendación de técnica Pomodoro (25 min)

---

### 8. TAREAS KANBAN (`/tareas`)

**Header:**
- Título con icono
- Botón "Nueva Tarea"

**Stats por Columna:**
- Pendientes (contador)
- En Progreso (contador)
- Completadas (contador)

**Tablero Kanban (3 Columnas):**
- **Pendientes** (Ámbar)
  - Icono: Clock
  - Color: amber-400
- **En Progreso** (Azul)
  - Icono: AlertCircle
  - Color: blue-400
- **Completadas** (Verde)
  - Icono: CheckCircle2
  - Color: green-400

**Cada Columna:**
- Header con icono, título, contador
- Botón "+" para agregar tarea en esa columna
- Lista de tareas (o mensaje "Sin tareas")

**Cada Tarea (Card):**
- Borde izquierdo según prioridad:
  - Rojo: Alta
  - Ámbar: Media
  - Verde: Baja
- Título
- Descripción (truncada a 2 líneas)
- Badge de prioridad
- Fecha límite (si tiene)
- Etiquetas (chips)
- Botones Editar/Eliminar
- Botón "Mover a [Siguiente Estado]" (si aplica)

**Modal Crear/Editar Tarea:**
- Título *
- Descripción (opcional)
- Prioridad * (Baja/Media/Alta)
- Fecha límite (opcional)
- Estado * (Pendiente/En Progreso/Completada)
- Etiquetas:
  - Input para agregar (Enter o botón +)
  - Lista de etiquetas con botón X para eliminar

**Prioridades:**
- 🟢 Baja (verde)
- 🟡 Media (ámbar)
- 🔴 Alta (roja)

**Funcionalidades:**
- Crear tarea
- Editar tarea
- Eliminar tarea (con confirmación)
- Mover tarea entre estados
- Agregar/eliminar etiquetas

**Tip TDAH:**
- Limitar tareas "En Progreso" a máximo 3
- Celebrar cada tarea completada

---

### 9. PAGOS ATRASADOS (`/atrasados`)

**Header:**
- Título con icono
- Botón "Registrar Atraso"

**Cards de Resumen:**
- Total Acumulado (rojo si hay, verde si está al día)
- Pagos Pendientes (cantidad)
- Mes Actual

**Estado General:**
- Si no hay atrasos: Card verde con mensaje "¡Todo al día!"
- Si hay atrasos:
  - Lista de pagos pendientes ordenados por fecha de vencimiento
  - Cada pago muestra:
    - Nombre de la deuda
    - Mes del pago
    - Días de atraso (o "Vence hoy")
    - Monto
    - Fecha de vencimiento original
    - Botón "Marcar como Pagado"
    - Botón Eliminar
  - Resumen por Concepto (si hay múltiples deudas)

**Modal Registrar Atraso:**
- Deuda relacionada (opcional, select)
- Mes del pago atrasado * (texto libre)
- Monto (Gs) *
- Fecha vencimiento original *

**Funcionalidades:**
- Registrar pago atrasado
- Marcar como pagado (elimina el registro)
- Eliminar registro (con confirmación)
- Cálculo de días de atraso

**Tip TDAH:**
- Configurar recordatorios 3 días antes
- Técnica "body doubling"

---

### 10. LOGS (`/logs`)

**Header:**
- Título con icono
- Botones: Refrescar, Exportar JSON, Eliminar logs antiguos

**Resumen de Últimos 14 Días:**
- Grid horizontal scrollable
- Cada día muestra:
  - Día de la semana
  - Día del mes
  - Total de logs
  - Cantidad de errores (si hay)
- Click en día para ver logs de esa fecha

**Controles:**
- Navegación de fecha (anterior/siguiente)
- Date picker
- Botón "Hoy"
- Filtro por Nivel (Todos/Debug/Info/Warning/Error)
- Filtro por Categoría

**Tabla de Logs:**
- Columnas:
  - Hora (formato HH:MM:SS)
  - Nivel (badge con icono y color)
  - Categoría
  - Mensaje
  - Metadata (expandible, JSON)
- Orden: Más recientes primero

**Niveles de Log:**
- 🔍 Debug (gris)
- ℹ️ Info (azul)
- ⚠️ Warning (ámbar)
- ❌ Error (rojo)

**Stats del Día:**
- Total logs
- Info
- Warnings
- Errores

**Funcionalidades:**
- Ver logs por fecha
- Filtrar por nivel y categoría
- Exportar logs a JSON
- Eliminar logs antiguos (más de 30 días)

---

### 11. CONFIGURACIÓN (`/configuracion`)

**Sección Tipo de Cambio:**
- Input para configurar 1 USD = X Gs
- Botón Guardar
- Valor actual mostrado

**Estadísticas de Datos:**
- Grid con contadores:
  - Deudas registradas
  - Suscripciones
  - Gastos registrados
  - Cursos
  - Tareas
  - Pagos atrasados

**Backup y Restauración:**
- Botón "Exportar Datos" (descarga JSON)
- Botón "Importar Datos" (sube JSON)
- Advertencia sobre reemplazo de datos

**Zona de Peligro:**
- Botón "Eliminar Todos los Datos"
- Confirmación doble
- Advertencia clara

**About:**
- Logo y nombre de la app
- Descripción
- Versión y tecnologías

**Tips para TDAH:**
- Grid con 4 tips:
  - Mantén listas cortas
  - Revisa a diario
  - Registra al momento
  - Celebra los logros

---

## 💾 MODELOS DE DATOS

### Deuda
```typescript
{
  id: string (UUID)
  nombre: string
  montoTotal: number
  cuotasMensuales: number
  cuotasPagadas: number
  montoCuota: number
  fechaInicio: string (YYYY-MM-DD)
  diaVencimiento: number (1-28)
  notas?: string
  created_at: timestamp
  updated_at: timestamp
}
```

### Suscripción
```typescript
{
  id: string (UUID)
  nombre: string
  monto: number
  moneda: 'USD' | 'GS'
  categoria: string
  fechaRenovacion: number (1-28)
  activa: boolean
  notas?: string
  created_at: timestamp
  updated_at: timestamp
}
```

### Gasto Diario
```typescript
{
  id: string (UUID)
  descripcion: string
  monto: number
  moneda: 'USD' | 'GS'
  categoria: string
  fecha: string (YYYY-MM-DD)
  notas?: string
  tarjetaId?: string (UUID)
  esCuotas: boolean
  numeroCuotas: number
  cuotaActual: number
  created_at: timestamp
}
```

### Tarjeta de Crédito
```typescript
{
  id: string (UUID)
  nombre: string
  banco?: string
  ultimosDigitos?: string
  limiteCredito?: number
  diaCierre: number (1-28)
  diaVencimiento: number (1-28)
  activa: boolean
  notas?: string
  created_at: timestamp
  updated_at: timestamp
}
```

### Curso
```typescript
{
  id: string (UUID)
  nombre: string
  plataforma: string
  url?: string
  diasAsignados: number[] (0=Domingo, 1=Lunes, etc.)
  horaInicio?: string (HH:MM)
  duracionMinutos?: number
  progreso: number (0-100)
  activo: boolean
  notas?: string
  created_at: timestamp
  updated_at: timestamp
}
```

### Tarea
```typescript
{
  id: string (UUID)
  titulo: string
  descripcion?: string
  estado: 'pendiente' | 'en_progreso' | 'completada'
  prioridad: 'baja' | 'media' | 'alta'
  fechaCreacion: string (YYYY-MM-DD)
  fechaLimite?: string (YYYY-MM-DD)
  etiquetas: string[]
  created_at: timestamp
  updated_at: timestamp
}
```

### Pago Atrasado
```typescript
{
  id: string (UUID)
  deudaId?: string (UUID)
  nombreDeuda: string
  mes: string
  monto: number
  fechaVencimiento: string (YYYY-MM-DD)
  created_at: timestamp
}
```

### Configuración Usuario
```typescript
{
  id: string (UUID)
  tipoCambioUSD: number (default: 7500)
  temaOscuro: boolean (default: true)
  created_at: timestamp
  updated_at: timestamp
}
```

### Log
```typescript
{
  id: string (UUID)
  nivel: 'debug' | 'info' | 'warn' | 'error'
  categoria: string
  mensaje: string
  metadata: Record<string, unknown>
  ip_address?: string
  user_agent?: string
  created_at: timestamp
}
```

---

## 🔐 AUTENTICACIÓN Y SEGURIDAD

### Flujo de Autenticación
1. Usuario se registra con email/contraseña
2. Supabase envía email de confirmación
3. Usuario confirma email
4. Usuario inicia sesión
5. Sesión se mantiene con cookies HttpOnly

### Row Level Security (RLS)
- Todas las tablas tienen RLS habilitado
- Políticas: Usuario solo puede ver/modificar sus propios datos
- Consultas automáticamente filtradas por `user_id`

### Middleware
- Verifica autenticación en rutas protegidas
- Redirige a `/login` si no está autenticado

---

## 🔄 FUNCIONALIDADES ESPECIALES

### Conversión de Monedas
- Configuración de tipo de cambio USD/GS
- Conversión automática en:
  - Suscripciones
  - Gastos
  - Cálculos de totales

### Cálculo de Cuotas
- Para gastos en cuotas:
  - Calcula cuota actual basado en fecha de compra y día de cierre
  - Muestra progreso (X/Y cuotas)
  - Calcula monto por cuota

### Resumen de Tarjetas
- Agrupa gastos por mes según día de cierre
- Calcula total a pagar (contado + cuotas)
- Calcula disponible (límite - gastos)
- Muestra barra de progreso de uso

### Vista Excel de Deudas
- Matriz de meses vs deudas
- Estados visuales por celda
- Navegación de años
- Columna fija para nombre de deuda

### Calendario Semanal de Cursos
- Vista de 7 días
- Muestra cursos asignados por día
- Destaca día actual

---

## 📱 PWA (Progressive Web App)

### Características
- Service Worker para funcionamiento offline
- Manifest.json para instalación
- Iconos en múltiples tamaños
- Splash screens para iOS
- Shortcuts: Gastos, Tareas

### Funcionalidad Offline
- Página offline personalizada
- Datos en caché cuando es posible

---

## 🎯 CONSIDERACIONES PARA FLUTTER

### Arquitectura Recomendada
- **State Management**: Provider, Riverpod, o Bloc
- **Navegación**: GoRouter o Navigator 2.0
- **Base de Datos Local**: Hive, SQLite, o Isar
- **Backend**: Supabase Flutter SDK
- **UI**: Material 3 o Cupertino con tema oscuro personalizado

### Componentes Clave a Recrear
1. **Sidebar/Drawer**: NavigationRail o Drawer
2. **Glass Cards**: Container con BackdropFilter
3. **Kanban Board**: ReorderableListView o paquete drag_and_drop
4. **Tabla Excel**: DataTable con scroll horizontal
5. **Calendario**: TableCalendar o custom
6. **Modales**: showModalBottomSheet o Dialog

### Funcionalidades Específicas
- **Drag & Drop**: Para Kanban (flutter_reorderable_list)
- **Charts**: Para visualizaciones (fl_chart)
- **Date Pickers**: Para fechas (flutter_datetime_picker)
- **Formatters**: Para monedas (intl package)

### Responsive Design
- Breakpoints: 640px (tablet), 768px (desktop)
- Layout adaptativo:
  - Mobile: Drawer oculto, botón hamburguesa
  - Tablet: Drawer colapsable
  - Desktop: Drawer siempre visible

### Tema Oscuro
- Replicar colores exactos
- Glassmorphism con BackdropFilter
- Gradientes en botones
- Animaciones suaves

---

## 📋 CHECKLIST DE IMPLEMENTACIÓN

### Fase 1: Setup y Autenticación
- [ ] Configurar proyecto Flutter
- [ ] Integrar Supabase Flutter SDK
- [ ] Pantallas de Login y Registro
- [ ] Manejo de sesión y navegación

### Fase 2: Navegación y Layout
- [ ] Sidebar/Drawer con todos los items
- [ ] Layout responsive
- [ ] Tema oscuro personalizado
- [ ] Componentes base (cards, botones, inputs)

### Fase 3: Módulos Financieros
- [ ] Dashboard con resúmenes
- [ ] Deudas (vista cards y tabla)
- [ ] Suscripciones
- [ ] Gastos Diarios
- [ ] Tarjetas de Crédito
- [ ] Pagos Atrasados

### Fase 4: Módulos de Productividad
- [ ] Tareas Kanban con drag & drop
- [ ] Cursos (vista lista y calendario)

### Fase 5: Utilidades
- [ ] Logs
- [ ] Configuración
- [ ] Backup/Exportación

### Fase 6: PWA y Optimizaciones
- [ ] Service Worker
- [ ] Manifest
- [ ] Iconos
- [ ] Funcionalidad offline básica

---

## 🎨 PALETA DE COLORES COMPLETA

```dart
class AppColors {
  // Backgrounds
  static const bgPrimary = Color(0xFF0F0F15);
  static const bgSecondary = Color(0xFF16161F);
  static const bgTertiary = Color(0xFF1E1E2A);
  static const bgCard = Color(0xFF1A1A24);
  static const borderColor = Color(0xFF2D2D3D);
  
  // Text
  static const textPrimary = Color(0xFFF5F5F8);
  static const textSecondary = Color(0xFFB0B0C0);
  static const textMuted = Color(0xFF707080);
  
  // Accents
  static const accentPrimary = Color(0xFF6366F1); // Indigo
  static const accentSecondary = Color(0xFF8B5CF6); // Purple
  static const accentSuccess = Color(0xFF22C55E);
  static const accentWarning = Color(0xFFF59E0B);
  static const accentDanger = Color(0xFFEF4444);
  static const accentInfo = Color(0xFF06B6D4);
  
  // Gradients
  static const gradientStart = Color(0xFF6366F1);
  static const gradientEnd = Color(0xFFA855F7);
}
```

---

## 📝 NOTAS FINALES

### Características TDAH-Friendly
- Listas cortas (máximo 5-7 tareas visibles)
- Registro inmediato de gastos
- Recordatorios visuales
- Celebración de logros
- Tips contextuales

### Mejoras Potenciales para Flutter
- Notificaciones push para recordatorios
- Widgets de home screen
- Integración con calendario del sistema
- Modo offline completo
- Sincronización en tiempo real

### Performance
- Lazy loading de listas largas
- Caché de datos frecuentes
- Optimización de imágenes
- Debounce en búsquedas/filtros

---

**Este documento contiene toda la información necesaria para recrear completamente la aplicación TDAH Organizer en Flutter. Cada pantalla, funcionalidad, modelo de datos y detalle de UI está documentado para facilitar la implementación.**

