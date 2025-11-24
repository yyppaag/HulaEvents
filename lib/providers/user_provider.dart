import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

/// 用户状态管理Provider
/// 管理用户登录状态、用户信息和订阅状态
class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  /// 获取当前用户
  User? get currentUser => _currentUser;

  /// 获取登录状态
  bool get isLoggedIn => _isLoggedIn;

  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// 用户是否是高级会员
  bool get isPremium => _currentUser?.isPremium ?? false;

  /// 用户是否是专业会员
  bool get isProfessional => _currentUser?.isProfessional ?? false;

  /// 订阅是否有效
  bool get isSubscriptionValid => _currentUser?.isSubscriptionValid ?? false;

  /// 时间线创建限制
  int get timelineCreateLimit => _currentUser?.timelineCreateLimit ?? 3;

  /// 事件创建限制
  int get eventCreateLimit => _currentUser?.eventCreateLimit ?? 10;

  /// 用户显示名称
  String get displayName {
    if (_currentUser == null) return '游客';
    return _currentUser!.displayName ?? _currentUser!.username;
  }

  /// 初始化用户状态
  /// 在应用启动时调用，检查是否已有用户登录
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      _isLoggedIn = await _authService.isLoggedIn();

      if (_isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '初始化用户状态失败: $e';
      notifyListeners();
    }
  }

  /// 用户注册
  ///
  /// 参数:
  /// - [username]: 用户名
  /// - [email]: 邮箱
  /// - [password]: 密码
  /// - [displayName]: 显示名称（可选）
  ///
  /// 返回:
  /// - 成功返回true
  /// - 失败返回false并设置错误信息
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.register(
        username: username,
        email: email,
        password: password,
        displayName: displayName,
      );

      // 注册成功后自动登录
      _currentUser = user;
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 用户登录
  ///
  /// 参数:
  /// - [usernameOrEmail]: 用户名或邮箱
  /// - [password]: 密码
  ///
  /// 返回:
  /// - 成功返回true
  /// - 失败返回false并设置错误信息
  Future<bool> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      _currentUser = user;
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 用户登出
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.logout();

      _currentUser = null;
      _isLoggedIn = false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '登出失败: $e';
      notifyListeners();
    }
  }

  /// 更新用户信息
  ///
  /// 参数:
  /// - [displayName]: 新的显示名称（可选）
  /// - [avatarUrl]: 新的头像URL（可选）
  Future<bool> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) {
      _errorMessage = '请先登录';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedUser = _currentUser!.copyWith(
        displayName: displayName,
        avatarUrl: avatarUrl,
      );

      await _authService.updateUser(updatedUser);
      _currentUser = updatedUser;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '更新用户信息失败: $e';
      notifyListeners();
      return false;
    }
  }

  /// 更改密码
  ///
  /// 参数:
  /// - [oldPassword]: 旧密码
  /// - [newPassword]: 新密码
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      _errorMessage = '请先登录';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.changePassword(
        userId: _currentUser!.id,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 升级订阅
  ///
  /// 参数:
  /// - [subscriptionType]: 订阅类型
  /// - [expiryDate]: 过期日期
  Future<bool> upgradeSubscription({
    required SubscriptionType subscriptionType,
    required DateTime expiryDate,
  }) async {
    if (_currentUser == null) {
      _errorMessage = '请先登录';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.upgradeSubscription(
        userId: _currentUser!.id,
        subscriptionType: subscriptionType,
        expiryDate: expiryDate,
      );

      // 更新当前用户信息
      _currentUser = _currentUser!.copyWith(
        subscriptionType: subscriptionType,
        subscriptionExpiryDate: expiryDate,
      );

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '升级订阅失败: $e';
      notifyListeners();
      return false;
    }
  }

  /// 检查时间线创建权限
  ///
  /// 参数:
  /// - [currentCount]: 当前已创建的时间线数量
  ///
  /// 返回:
  /// - 允许创建返回true
  /// - 超出限制返回false并设置错误信息
  bool canCreateTimeline(int currentCount) {
    if (_currentUser == null) {
      _errorMessage = '请先登录';
      notifyListeners();
      return false;
    }

    final limit = timelineCreateLimit;

    // 高级会员无限制
    if (limit == -1) {
      return true;
    }

    if (currentCount >= limit) {
      _errorMessage = '已达到时间线创建上限（$limit个），请升级会员以创建更多时间线';
      notifyListeners();
      return false;
    }

    return true;
  }

  /// 检查事件创建权限
  ///
  /// 参数:
  /// - [currentCount]: 当前时间线中已有的事件数量
  ///
  /// 返回:
  /// - 允许创建返回true
  /// - 超出限制返回false并设置错误信息
  bool canCreateEvent(int currentCount) {
    if (_currentUser == null) {
      _errorMessage = '请先登录';
      notifyListeners();
      return false;
    }

    final limit = eventCreateLimit;

    // 高级会员无限制
    if (limit == -1) {
      return true;
    }

    if (currentCount >= limit) {
      _errorMessage = '单个时间线最多添加$limit个事件，请升级会员以添加更多事件';
      notifyListeners();
      return false;
    }

    return true;
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
