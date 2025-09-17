import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/injection/injection_container.dart';
import '../../data/repositories/branch_repository.dart';
import '../../data/models/branch_model.dart';
import '../../data/models/create_branch_request.dart';
import '../bloc/branch_bloc.dart';

class EditBranchDialog extends StatefulWidget {
  final BranchModel branch;
  final VoidCallback? onBranchUpdated;

  const EditBranchDialog({
    super.key,
    required this.branch,
    this.onBranchUpdated,
  });

  @override
  State<EditBranchDialog> createState() => _EditBranchDialogState();
}

class _EditBranchDialogState extends State<EditBranchDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.branch.name);
    _addressController = TextEditingController(text: widget.branch.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateBranch() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = sl<BranchRepository>();
      final request = CreateBranchRequest(
        name: _nameController.text.trim(),
        address: _addressController.text.trim().isNotEmpty 
            ? _addressController.text.trim() 
            : null,
      );

      await repository.updateBranch(widget.branch.id, request);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Trigger BLoC to reload branches
        context.read<BranchBloc>().add(LoadBranches());
        
        // Call the callback if provided
        widget.onBranchUpdated?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Branch "${_nameController.text}" updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update branch: $e'),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.edit, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text('Edit ${widget.branch.name}')),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Branch Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Branch Name *',
                hintText: 'Enter branch name',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Branch name is required';
                }
                if (value.trim().length < 2) {
                  return 'Branch name must be at least 2 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Address Field
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address (Optional)',
                hintText: 'Enter branch address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateBranch,
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