# 🗺️ ROADMAP - TDAH Organizer

## 📊 Estado Actual

### ✅ Completado
- [x] Configuración del proyecto y tema visual
- [x] Navegación y layout principal
- [x] Sistema de gestión de estado con Provider
- [x] Dashboard básico
- [x] Deudas (vista cards y tabla)
- [x] Suscripciones
- [x] Gastos Diarios
- [x] Tareas (lista básica)
- [x] Notas
- [x] Temporizador Pomodoro (Focus)
- [x] Sistema de moneda configurable (PYG por defecto)
- [x] Pantalla de Configuración
- [x] Persistencia de configuración

---

## 🎯 ROADMAP DE IMPLEMENTACIÓN

### **FASE 1: Funcionalidades Financieras Core** (Prioridad Alta)

#### 1.1 Tarjetas de Crédito (`/tarjetas`)
**Estado:** ❌ No implementado  
**Prioridad:** 🔴 Alta  
**Complejidad:** Media

**Funcionalidades:**
- [ ] Modelo `CreditCard`
- [ ] Provider `CreditCardProvider`
- [ ] Pantalla principal con grid de tarjetas
- [ ] Resumen mensual por tarjeta (agrupado por día de cierre)
- [ ] Cálculo de total a pagar (contado + cuotas)
- [ ] Cálculo de disponible (límite - gastos)
- [ ] Barra de progreso de uso
- [ ] Lista expandible de gastos por tarjeta
- [ ] Modal crear/editar tarjeta
- [ ] Activar/Desactivar tarjeta
- [ ] Asociar gastos a tarjetas
- [ ] Cálculo de cuota actual para gastos en cuotas

**Dependencias:**
- Modelo Expense debe tener `tarjetaId` y campos de cuotas
- Integración con ExpenseProvider

---

#### 1.2 Pagos Atrasados (`/atrasados`)
**Estado:** ❌ No implementado  
**Prioridad:** 🔴 Alta  
**Complejidad:** Baja-Media

**Funcionalidades:**
- [ ] Modelo `OverduePayment`
- [ ] Provider `OverduePaymentProvider`
- [ ] Pantalla principal con cards de resumen
- [ ] Lista de pagos pendientes ordenados por fecha
- [ ] Cálculo automático de días de atraso
- [ ] Estado "Todo al día" cuando no hay atrasos
- [ ] Modal registrar atraso manual
- [ ] Marcar como pagado
- [ ] Resumen por concepto
- [ ] Integración con DebtProvider para detectar atrasos automáticamente

**Dependencias:**
- DebtProvider debe calcular atrasos basado en fechas de vencimiento

---

### **FASE 2: Módulos de Productividad** (Prioridad Media-Alta)

#### 2.1 Cursos & Educación (`/cursos`)
**Estado:** ⚠️ Parcial (solo focus_mode_screen básico)  
**Prioridad:** 🟡 Media-Alta  
**Complejidad:** Media

**Funcionalidades:**
- [ ] Modelo `Course`
- [ ] Provider `CourseProvider`
- [ ] Vista Lista con grid responsive
- [ ] Vista Calendario semanal (7 días)
- [ ] Cards de resumen (activos, pausados, para hoy, progreso promedio)
- [ ] Sección "Cursos para Hoy"
- [ ] Filtros (Todos/Activos/Pausados)
- [ ] Modal crear/editar curso
- [ ] Asignar días de estudio (checkboxes L-D)
- [ ] Hora de inicio y duración
- [ ] Actualizar progreso (%)
- [ ] Activar/Pausar curso
- [ ] Plataformas disponibles (select)
- [ ] Link externo a curso

**Dependencias:**
- Calendario widget o TableCalendar package

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

### **FASE 6: Persistencia de Datos** (Prioridad Alta - Próximo paso)

#### 6.1 Almacenamiento Local
**Estado:** ⚠️ Solo configuración  
**Prioridad:** 🔴 Alta  
**Complejidad:** Media

**Funcionalidades:**
- [ ] Integrar Hive o Isar para persistencia local
- [ ] Migrar todos los providers a usar almacenamiento persistente
- [ ] Sincronización inicial de datos de muestra
- [ ] Manejo de migraciones de datos

**Dependencias:**
- Package Hive o Isar
- Modelos deben ser serializables

---

## 📅 Orden de Implementación Recomendado

### Sprint 1: Funcionalidades Financieras Core
1. **Tarjetas de Crédito** (2-3 días)
2. **Pagos Atrasados** (1-2 días)
3. **Mejoras al Dashboard** (1 día)

### Sprint 2: Persistencia y Productividad
4. **Persistencia Local (Hive/Isar)** (2-3 días)
5. **Cursos & Educación** (2-3 días)

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

### Fase 1-3: Funcionalidades Base ✅
- Todas las funcionalidades core implementadas
- Datos persistentes localmente
- UI/UX completa según documentación

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

**Última actualización:** 2024
**Estado del Proyecto:** En desarrollo activo

