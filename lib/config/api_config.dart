class ApiConfig {
  static const String BASE_URL = 'https://agentra-backend.vercel.app/api';
  // static const String BASE_URL = 'http://10.0.2.2:5000/api'; // For Android Emulator
  
  // Use this for Web or iOS Simulator:
  // static const String BASE_URL = 'http://localhost:5000/api';

  // ===== AUTH ENDPOINTS =====
  static const String AGENT_REGISTER = '$BASE_URL/auth/agent/register';
  static const String AGENT_LOGIN = '$BASE_URL/auth/agent/login';
  
  // ===== PACKAGE ENDPOINTS =====
  static const String PACKAGES = '$BASE_URL/packages';
  static const String AGENT_PACKAGES = '$BASE_URL/packages/agent';
  static String packageDetail(String id) => '$BASE_URL/packages/$id';
  
  // ===== AGENT ENDPOINTS =====
  static const String AGENT_PROFILE = '$BASE_URL/auth/agent/profile';
  static const String UPDATE_AGENT_PROFILE = '$BASE_URL/auth/agent/profile';
  static const String AGENT_DASHBOARD = '$BASE_URL/dashboard/agent';

  // ===== ADMIN ENDPOINTS =====
  static const String OWNER_LOGIN = '$BASE_URL/auth/owner/login';
  static const String UNVERIFIED_AGENTS = '$BASE_URL/auth/owner/agents';
  static String verifyAgent(String id) => '$BASE_URL/auth/owner/agents/$id/verify';
}
