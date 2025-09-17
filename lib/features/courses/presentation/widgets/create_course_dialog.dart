
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/injection_container.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/models/course_model.dart';
import '../../../branches/data/models/branch_model.dart';
import '../../../branches/data/repositories/branch_repository.dart';
import '../bloc/course_bloc.dart';

class CreateCourseDialog extends StatefulWidget {
  final VoidCallback? onCourseCreated;
  final int branchId;

  const CreateCourseDialog({
    super.key,
    required this.branchId,
    this.onCourseCreated,
  });

  @override
  State<CreateCourseDialog> createState() => _CreateCourseDialogState();
}

class _CreateCourseDialogState extends State<CreateCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  
  int? _selectedBranchId;
  List<BranchModel> _branches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    try {
      final repository = sl<BranchRepository>();
      final branches = await repository.getAllBranches();
      if (mounted) {
        setState(() {
          _branches = branches;
          if (branches.isNotEmpty) {
            _selectedBranchId = branches.first.id;
          }
        });
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = sl<CourseRepository>();
      final request = CreateCourseRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        price: int.parse(_priceController.text),
        durationMonths: int.parse(_durationController.text),
        branchId: _selectedBranchId!,
      );

      await repository.createCourse(request);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Trigger BLoC to reload courses
        context.read<CourseBloc>().add(LoadCoursesByBranch(widget.branchId));
        
        // Call the callback if provided
        widget.onCourseCreated?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text('Course "${_nameController.text}" created successfully'),
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
                Expanded(child: Text('Failed to create course: $e')),
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
                color: Colors.indigo.withOpacity(0.05),
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
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Create New Course',
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
                      // Course Name Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Course Name',
                            hintText: 'Enter course name',
                            prefixIcon: Icon(Icons.school_outlined),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Course name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Course name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description (Optional)',
                            hintText: 'Enter course description',
                            prefixIcon: Icon(Icons.description_outlined),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Price and Duration Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Price',
                                  hintText: 'Enter price',
                                  prefixIcon: Icon(Icons.attach_money_rounded),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Price is required';
                                  }
                                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                    return 'Enter valid price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Duration (months)',
                                  hintText: 'Months',
                                  prefixIcon: Icon(Icons.schedule_rounded),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Duration is required';
                                  }
                                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                    return 'Enter valid duration';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Branch Selection
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
                            labelText: 'Branch',
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
                            if (value == null) {
                              return 'Please select a branch';
                            }
                            return null;
                          },
                        ),
                      ),
                      
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
                              onPressed: _isLoading ? null : _createCourse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
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