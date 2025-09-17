import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/injection_container.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_bloc.dart';
import '../../../branches/data/models/branch_model.dart';
import '../../../branches/data/repositories/branch_repository.dart';

class CreateUserDialog extends StatefulWidget {
  final VoidCallback? onUserCreated;

  const CreateUserDialog({
    super.key,
    this.onUserCreated,
  });

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedRole = 'ADMIN';
  int? _selectedBranchId;
  List<BranchModel> _branches = [];
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    try {
      final repository = sl<BranchRepository>();
      final branches = await repository.getAllBranches();
      if (mounted) {
        setState(() {
          _branches = branches;
          if (branches.isNotEmpty && _selectedRole == 'ADMIN') {
            _selectedBranchId = branches.first.id;
          }
        });
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = sl<UserRepository>();
      final request = CreateUserRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
        branchId: _selectedRole == 'ADMIN' ? _selectedBranchId : null,
      );

      await repository.createUser(request);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Trigger BLoC to reload users
        context.read<UserBloc>().add(LoadUsers());
        
        // Call the callback if provided
        widget.onUserCreated?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text('User "${_usernameController.text}" created successfully'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to create user: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Create New User',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: Colors.grey[600]),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter username',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username is required';
                            }
                            if (value.trim().length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword 
                                    ? Icons.visibility_off_rounded 
                                    : Icons.visibility_rounded,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Role Selection
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            prefixIcon: Icon(Icons.admin_panel_settings_rounded),
                            border: InputBorder.none,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'SUPER_ADMIN',
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(Icons.admin_panel_settings_rounded, 
                                         color: Colors.purple, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('SUPER_ADMIN'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'ADMIN',
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(Icons.manage_accounts_rounded, 
                                         color: Colors.blue, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('ADMIN'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                              if (_selectedRole == 'SUPER_ADMIN') {
                                _selectedBranchId = null;
                              } else if (_branches.isNotEmpty) {
                                _selectedBranchId = _selectedBranchId ?? _branches.first.id;
                              }
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Branch Selection (only for ADMIN role)
                      if (_selectedRole == 'ADMIN') ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: _selectedBranchId,
                            decoration: const InputDecoration(
                              labelText: 'Assigned Branch',
                              prefixIcon: Icon(Icons.business_rounded),
                              border: InputBorder.none,
                            ),
                            items: _branches.map((branch) => DropdownMenuItem(
                              value: branch.id,
                              child: Text(branch.name),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBranchId = value;
                              });
                            },
                            validator: (value) {
                              if (_selectedRole == 'ADMIN' && value == null) {
                                return 'Please select a branch for ADMIN role';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: Colors.grey[100],
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _createUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Create',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}