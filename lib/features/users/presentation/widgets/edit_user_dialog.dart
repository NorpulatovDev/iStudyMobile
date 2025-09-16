import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/injection/injection_container.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../../branches/data/models/branch_model.dart';
import '../../../branches/data/repositories/branch_repository.dart';

class EditUserDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onUserUpdated;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  
  late String _selectedRole;
  int? _selectedBranchId;
  List<BranchModel> _branches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _selectedRole = widget.user.role;
    _selectedBranchId = widget.user.branchId;
    _loadBranches();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    try {
      final repository = sl<BranchRepository>();
      final branches = await repository.getAllBranches();
      if (mounted) {
        setState(() {
          _branches = branches;
          // If user doesn't have a branch but role is ADMIN, assign first branch
          if (_selectedRole == 'ADMIN' && _selectedBranchId == null && branches.isNotEmpty) {
            _selectedBranchId = branches.first.id;
          }
        });
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = sl<UserRepository>();
      final request = UpdateUserRequest(
        username: _usernameController.text.trim(),
        role: _selectedRole,
        branchId: _selectedRole == 'ADMIN' ? _selectedBranchId : null,
      );

      await repository.updateUser(widget.user.id, request);
      
      if (mounted) {
        Navigator.of(context).pop();
        widget.onUserUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User "${_usernameController.text}" updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user: $e'),
            backgroundColor: Colors.red,
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
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.edit, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text('Edit ${widget.user.username}'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username *',
                  hintText: 'Enter username',
                  prefixIcon: Icon(Icons.person_outline),
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
              
              const SizedBox(height: 16),
              
              // Role Selection
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role *',
                  prefixIcon: Icon(Icons.admin_panel_settings),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'SUPER_ADMIN',
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: Colors.purple, size: 20),
                        SizedBox(width: 8),
                        Text('SUPER_ADMIN'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ADMIN',
                    child: Row(
                      children: [
                        Icon(Icons.manage_accounts, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text('ADMIN'),
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
              
              const SizedBox(height: 16),
              
              // Branch Selection (only for ADMIN role)
              if (_selectedRole == 'ADMIN') ...[
                DropdownButtonFormField<int>(
                  value: _selectedBranchId,
                  decoration: const InputDecoration(
                    labelText: 'Assigned Branch *',
                    prefixIcon: Icon(Icons.business),
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
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
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
              : const Text('Update'),
        ),
      ],
    );
  }
}