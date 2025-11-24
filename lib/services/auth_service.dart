import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'storage_service.dart';

/// 认证服务类
/// 处理用户注册、登录、登出等认证相关功能
class AuthService {
  static const String _currentUserIdKey = 'current_user_id';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userBoxKey = 'users';

  final StorageService _storageService = StorageService();
  final _uuid = const Uuid();

  /// 注册新用户
  ///
  /// 参数:
  /// - [username]: 用户名 (必填)
  /// - [email]: 邮箱地址 (必填)
  /// - [password]: 密码 (必填)
  /// - [displayName]: 显示名称 (可选)
  ///
  /// 返回:
  /// - 成功返回创建的User对象
  /// - 失败抛出异常
  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // 验证输入
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('用户名、邮箱和密码不能为空');
      }

      // 验证邮箱格式
      if (!_isValidEmail(email)) {
        throw Exception('邮箱格式不正确');
      }

      // 验证密码强度
      if (password.length < 6) {
        throw Exception('密码长度至少为6个字符');
      }

      // 检查用户名是否已存在
      if (await _usernameExists(username)) {
        throw Exception('用户名已存在');
      }

      // 检查邮箱是否已注册
      if (await _emailExists(email)) {
        throw Exception('该邮箱已被注册');
      }

      // 创建用户对象
      final now = DateTime.now();
      final user = User(
        id: _uuid.v4(),
        username: username,
        email: email,
        displayName: displayName,
        subscriptionType: SubscriptionType.free,
        createdAt: now,
        lastLoginAt: now,
      );

      // 保存密码哈希
      await _savePasswordHash(user.id, password);

      // 保存用户信息
      await _saveUser(user);

      return user;
    } catch (e) {
      throw Exception('注册失败: $e');
    }
  }

  /// 用户登录
  ///
  /// 参数:
  /// - [usernameOrEmail]: 用户名或邮箱
  /// - [password]: 密码
  ///
  /// 返回:
  /// - 成功返回User对象并设置登录状态
  /// - 失败抛出异常
  Future<User> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      // 验证输入
      if (usernameOrEmail.isEmpty || password.isEmpty) {
        throw Exception('用户名/邮箱和密码不能为空');
      }

      // 查找用户
      final user = await _findUserByUsernameOrEmail(usernameOrEmail);
      if (user == null) {
        throw Exception('用户不存在');
      }

      // 验证密码
      final isPasswordValid = await _verifyPassword(user.id, password);
      if (!isPasswordValid) {
        throw Exception('密码错误');
      }

      // 更新最后登录时间
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      await _saveUser(updatedUser);

      // 设置登录状态
      await _setLoginState(updatedUser.id);

      return updatedUser;
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  /// 用户登出
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserIdKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      throw Exception('登出失败: $e');
    }
  }

  /// 检查用户是否已登录
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 获取当前登录用户
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_currentUserIdKey);

      if (userId == null) {
        return null;
      }

      return await _getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  /// 更新用户信息
  Future<void> updateUser(User user) async {
    try {
      await _saveUser(user);
    } catch (e) {
      throw Exception('更新用户信息失败: $e');
    }
  }

  /// 更改密码
  ///
  /// 参数:
  /// - [userId]: 用户ID
  /// - [oldPassword]: 旧密码
  /// - [newPassword]: 新密码
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // 验证旧密码
      final isOldPasswordValid = await _verifyPassword(userId, oldPassword);
      if (!isOldPasswordValid) {
        throw Exception('旧密码错误');
      }

      // 验证新密码强度
      if (newPassword.length < 6) {
        throw Exception('新密码长度至少为6个字符');
      }

      // 保存新密码
      await _savePasswordHash(userId, newPassword);
    } catch (e) {
      throw Exception('更改密码失败: $e');
    }
  }

  /// 升级用户订阅
  Future<void> upgradeSubscription({
    required String userId,
    required SubscriptionType subscriptionType,
    required DateTime expiryDate,
  }) async {
    try {
      final user = await _getUserById(userId);
      if (user == null) {
        throw Exception('用户不存在');
      }

      final updatedUser = user.copyWith(
        subscriptionType: subscriptionType,
        subscriptionExpiryDate: expiryDate,
      );

      await _saveUser(updatedUser);
    } catch (e) {
      throw Exception('升级订阅失败: $e');
    }
  }

  // ============ 私有辅助方法 ============

  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// 检查用户名是否存在
  Future<bool> _usernameExists(String username) async {
    final users = await _getAllUsers();
    return users.any((user) => user.username.toLowerCase() == username.toLowerCase());
  }

  /// 检查邮箱是否存在
  Future<bool> _emailExists(String email) async {
    final users = await _getAllUsers();
    return users.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  /// 根据用户名或邮箱查找用户
  Future<User?> _findUserByUsernameOrEmail(String usernameOrEmail) async {
    final users = await _getAllUsers();
    final normalizedInput = usernameOrEmail.toLowerCase();

    try {
      return users.firstWhere(
        (user) =>
            user.username.toLowerCase() == normalizedInput ||
            user.email.toLowerCase() == normalizedInput,
      );
    } catch (e) {
      return null;
    }
  }

  /// 根据ID获取用户
  Future<User?> _getUserById(String userId) async {
    try {
      return _storageService.getUser(userId);
    } catch (e) {
      return null;
    }
  }

  /// 获取所有用户
  Future<List<User>> _getAllUsers() async {
    try {
      return _storageService.getAllUsers();
    } catch (e) {
      return [];
    }
  }

  /// 保存用户
  Future<void> _saveUser(User user) async {
    await _storageService.saveUser(user);
  }

  /// 生成密码哈希
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// 保存密码哈希
  Future<void> _savePasswordHash(String userId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final passwordHash = _hashPassword(password);
    await prefs.setString('password_$userId', passwordHash);
  }

  /// 验证密码
  Future<bool> _verifyPassword(String userId, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedHash = prefs.getString('password_$userId');

      if (storedHash == null) {
        return false;
      }

      final inputHash = _hashPassword(password);
      return storedHash == inputHash;
    } catch (e) {
      return false;
    }
  }

  /// 设置登录状态
  Future<void> _setLoginState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);
    await prefs.setBool(_isLoggedInKey, true);
  }
}
