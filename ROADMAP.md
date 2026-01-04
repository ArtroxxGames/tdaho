# 🗺️ ROADMAP - TDAH Organizer

## 📊 Estado Actual

### ✅ Completado
- [x] Configuración del proyecto y tema visual
- [x] Navegación y layout principal
- [x] Sistema de gestión de estado con Provider
- [x] Dashboard completo con todas las secciones
- [x] Deudas (vista cards y tabla parcial)
- [x] Suscripciones
- [x] Gastos Diarios
- [x] Tarjetas de Crédito
- [x] Pagos Atrasados
- [x] Tareas (lista básica)
- [x] Cursos & Educación (módulo completo) ⭐ **NUEVO**
- [x] Notas
- [x] Temporizador Pomodoro (Focus)
- [x] Sistema de moneda configurable (PYG por defecto)
- [x] Pantalla de Configuración
- [x] Persistencia de configuración
- [x] **Persistencia de Datos con Hive** ⭐ **NUEVO** - Todos los providers

---

## 🎯 ROADMAP DE IMPLEMENTACIÓN

### **FASE 1: Funcionalidades Financieras Core** (Prioridad Alta)

#### 1.1 Tarjetas de Crédito (`/tarjetas`)
**Estado:** ✅ Completado  
**Prioridad:** 🔴 Alta  
**Complejidad:** Media

**Funcionalidades:**
- [x] Modelo `CreditCard` con serialización
- [x] Provider `CreditCardProvider` con persistencia Hive
- [x] Pantalla principal con grid de tarjetas
- [x] Resumen mensual por tarjeta (agrupado por día de cierre)
- [x] Cálculo de total a pagar (contado + cuotas)
- [x] Cálculo de disponible (límite - gastos)
- [x] Barra de progreso de uso
- [x] Lista expandible de gastos por tarjeta
- [x] Modal crear/editar tarjeta
- [x] Activar/Desactivar tarjeta
- [x] Asociar gastos a tarjetas
- [x] Cálculo de cuota actual para gastos en cuotas

---

#### 1.2 Pagos Atrasados (`/atrasados`)
**Estado:** ✅ Completado  
**Prioridad:** 🔴 Alta  
**Complejidad:** Baja-Media

**Funcionalidades:**
- [x] Modelo `OverduePayment` con serialización
- [x] Provider `OverduePaymentProvider` con persistencia Hive
- [x] Pantalla principal con cards de resumen
- [x] Lista de pagos pendientes ordenados por fecha
- [x] Cálculo automático de días de atraso
- [x] Estado "Todo al día" cuando no hay atrasos
- [x] Modal registrar atraso manual
- [x] Marcar como pagado
- [x] Resumen por concepto
- [x] Integración con DebtProvider para detectar atrasos automáticamente

---

### **FASE 2: Módulos de Productividad** (Prioridad Media-Alta)

#### 2.1 Cursos & Educación (`/cursos`)
**Estado:** ✅ Completado  
**Prioridad:** 🟡 Media-Alta  
**Complejidad:** Media

**Funcionalidades:**
- [x] Modelo `Course` con serialización completa
- [x] Provider `CourseProvider` con persistencia Hive
- [x] Vista Lista con grid responsive (1/2/3 columnas)
- [x] Vista Calendario semanal (7 días, L-D) con día actual destacado
- [x] Cards de resumen (activos, pausados, para hoy, progreso promedio)
- [x] Sección "Cursos para Hoy" con cards horizontales scrollables
- [x] Filtros (Todos/Activos/Pausados)
- [x] Modal crear/editar curso completo
- [x] Asignar días de estudio (chips interactivos L-D)
- [x] Hora de inicio (time picker) y duración
- [x] Actualizar progreso (%)
- [x] Activar/Pausar curso
- [x] 10 Plataformas disponibles (select)
- [x] Link externo a curso
- [x] Integrado en Dashboard
- [x] Agregado a navegación principal

---

#### 2.2 Tareas Kanban Mejorado (`/tareas`)
**Estado:** ⚠️ Básico (solo lista)  
**Prioridad:** 🟡 Media  
**Complejidad:** Media-Alta

**Funcionalidades:**
- [ ] Vista Kanban con 3 columnas (Pendientes, En Progreso, Completadas)
- [ ] Drag & Drop entre columnas
- [ ] Stats por columna (contadores)
- [ ] Cards de tarea con borde de prioridad
- [ ] Badge de prioridad
- [ ] Etiquetas (chips)
- [ ] Botón "Mover a siguiente estado"
- [ ] Límite de 3 tareas "En Progreso" (tip TDAH)
- [ ] Animaciones al mover tareas
- [ ] Mejorar modal con etiquetas

**Dependencias:**
- Package para drag & drop (flutter_reorderable_list o similar)

---

### **FASE 3: Utilidades y Sistema** (Prioridad Media)

#### 3.1 Logs (`/logs`)
**Estado:** ❌ No implementado  
**Prioridad:** 🟡 Media  
**Complejidad:** Media

**Funcionalidades:**
- [ ] Modelo `Log`
- [ ] Provider `LogProvider`
- [ ] Sistema de logging (debug, info, warning, error)
- [ ] Pantalla principal con tabla de logs
- [ ] Resumen de últimos 14 días (grid scrollable)
- [ ] Filtros por nivel y categoría
- [ ] Navegación de fecha (anterior/siguiente)
- [ ] Date picker
- [ ] Exportar logs a JSON
- [ ] Eliminar logs antiguos (>30 días)
- [ ] Metadata expandible (JSON)
- [ ] Integración de logging en toda la app

**Dependencias:**
- Sistema de logging centralizado

---

#### 3.2 Backup y Exportación
**Estado:** ❌ No implementado  
**Prioridad:** 🟡 Media  
**Complejidad:** Baja

**Funcionalidades:**
- [ ] Exportar todos los datos a JSON
- [ ] Importar datos desde JSON
- [ ] Validación de datos importados
- [ ] Advertencia sobre reemplazo de datos
- [ ] Botones en pantalla de Configuración
- [ ] Manejo de errores en importación

**Dependencias:**
- File picker package para importar
- Path provider para guardar exportaciones

---

### **FASE 4: Mejoras al Dashboard** (Prioridad Media)

#### 4.1 Dashboard Completo
**Estado:** ⚠️ Básico  
**Prioridad:** 🟡 Media  
**Complejidad:** Media

**Funcionalidades:**
- [ ] Cards de resumen mejorados (Cuotas Mensuales, Suscripciones, Pagos Atrasados, Gastos de Hoy)
- [ ] Card "Total Gastos Fijos Mensuales" (cuotas + suscripciones)
- [ ] Sección Productividad (Tareas Kanban, Educación)
- [ ] Acciones Rápidas (grid con botones: + Gasto, + Tarea, + Deuda, + Suscripción)
- [ ] Tip del Día (mensajes motivacionales TDAH)
- [ ] Carrusel de acciones rápidas (ya existe, mejorar)
- [ ] Gráficos simples (opcional, con fl_chart)

---

### **FASE 5: Autenticación y Backend** (Prioridad Baja - Para después)

#### 5.1 Autenticación
**Estado:** ❌ No implementado  
**Prioridad:** 🟢 Baja (para después)  
**Complejidad:** Alta

**Funcionalidades:**
- [ ] Pantalla de Login
- [ ] Pantalla de Registro
- [ ] Integración con Supabase Auth
- [ ] Manejo de sesión
- [ ] Middleware de autenticación
- [ ] Recuperación de contraseña

**Nota:** Esta fase se implementará cuando se integre el backend completo.

---

### **FASE 6: Persistencia de Datos** ✅ **COMPLETADA**

#### 6.1 Almacenamiento Local
**Estado:** ✅ Completado  
**Prioridad:** 🔴 Alta  
**Complejidad:** Media

**Funcionalidades:**
- [x] Integrado Hive y hive_flutter para persistencia local
- [x] Creado `StorageService` centralizado
- [x] Migrados todos los providers a usar almacenamiento persistente:
  - [x] `DebtProvider`
  - [x] `SubscriptionProvider`
  - [x] `ExpenseProvider`
  - [x] `CreditCardProvider`
  - [x] `OverduePaymentProvider`
  - [x] `TaskProvider`
  - [x] `NoteProvider`
  - [x] `CourseProvider`
- [x] Todos los modelos son serializables (toJson/fromJson)
- [x] Carga inicial de datos al iniciar app
- [x] Datos de muestra se cargan automáticamente si la caja está vacía
- [x] Actualizadas todas las pantallas para usar métodos async

---

## 📅 Orden de Implementación Recomendado

### Sprint 1: Funcionalidades Financieras Core
1. **Tarjetas de Crédito** (2-3 días)
2. **Pagos Atrasados** (1-2 días)
3. **Mejoras al Dashboard** (1 día)

### Sprint 2: Persistencia y Productividad ✅ **COMPLETADO**
4. ✅ **Persistencia Local (Hive)** (2-3 días) - **COMPLETADO**
5. ✅ **Cursos & Educación** (2-3 días) - **COMPLETADO**

### Sprint 3: Mejoras y Utilidades
6. **Tareas Kanban Mejorado** (2 días)
7. **Logs** (1-2 días)
8. **Backup/Exportación** (1 día)

### Sprint 4: Refinamiento
9. **Testing y correcciones**
10. **Optimizaciones**
11. **Documentación final**

---

## 🎯 Objetivos por Fase

### Fase 1-3: Funcionalidades Base ✅ **COMPLETADA**
- ✅ Todas las funcionalidades core implementadas
- ✅ Datos persistentes localmente (Hive)
- ✅ UI/UX completa según documentación
- ✅ Módulo Cursos & Educación completo

### Fase 4-5: Mejoras y Backend 🔄
- Autenticación
- Sincronización con backend
- Mejoras de UX

---

## 📝 Notas Importantes

- **Escalabilidad:** Todos los modelos y providers deben ser fácilmente extensibles
- **Testing:** Agregar tests unitarios después de cada funcionalidad
- **Documentación:** Mantener código documentado
- **UX TDAH-Friendly:** Recordar características especiales (listas cortas, recordatorios visuales, etc.)

---

**Última actualización:** Diciembre 2024
**Estado del Proyecto:** En desarrollo activo - **App Funcional** ✅

---

## 🎉 PROGRESO RECIENTE (Diciembre 2024)

### ✅ Completado Recientemente:
1. **Persistencia de Datos Completa:** Todos los providers migrados a Hive
2. **Módulo Cursos & Educación:** Implementación completa con todas las funcionalidades
3. **App Funcional:** Los datos ahora persisten entre sesiones

### 📊 Completitud Actual: **~80%** (aumentó desde 65%)

