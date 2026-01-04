/// Endpoints de la API
/// Se usarán cuando se implemente el backend
class ApiEndpoints {
  // ============ AUTH ============
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String me = '/auth/me';

  // ============ DEUDAS ============
  static const String debts = '/debts';
  static String debt(String id) => '/debts/$id';
  static String debtPayment(String debtId, int installment) => 
      '/debts/$debtId/payments/$installment';

  // ============ SUSCRIPCIONES ============
  static const String subscriptions = '/subscriptions';
  static String subscription(String id) => '/subscriptions/$id';

  // ============ GASTOS ============
  static const String expenses = '/expenses';
  static String expense(String id) => '/expenses/$id';
  static const String expensesByDate = '/expenses/by-date';
  static const String expensesByCategory = '/expenses/by-category';

  // ============ TARJETAS DE CRÉDITO ============
  static const String creditCards = '/credit-cards';
  static String creditCard(String id) => '/credit-cards/$id';
  static String creditCardSummary(String id) => '/credit-cards/$id/summary';

  // ============ PAGOS ATRASADOS ============
  static const String overduePayments = '/overdue-payments';
  static String overduePayment(String id) => '/overdue-payments/$id';

  // ============ TAREAS ============
  static const String tasks = '/tasks';
  static String task(String id) => '/tasks/$id';
  static String taskStatus(String id) => '/tasks/$id/status';

  // ============ NOTAS ============
  static const String notes = '/notes';
  static String note(String id) => '/notes/$id';

  // ============ CURSOS ============
  static const String courses = '/courses';
  static String course(String id) => '/courses/$id';
  static String courseProgress(String id) => '/courses/$id/progress';

  // ============ CONFIGURACIÓN ============
  static const String settings = '/settings';
  static const String exchangeRate = '/settings/exchange-rate';

  // ============ BACKUP ============
  static const String backup = '/backup';
  static const String backupExport = '/backup/export';
  static const String backupImport = '/backup/import';

  // ============ LOGS ============
  static const String logs = '/logs';
  static const String logsExport = '/logs/export';
}

