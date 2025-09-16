import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/branch_bloc.dart';
import '../../data/models/branch_model.dart';

class BranchSelector extends StatelessWidget {
  final Function(BranchModel) onBranchSelected;
  final BranchModel? currentSelectedBranch;

  const BranchSelector({
    super.key,
    required this.onBranchSelected,
    this.currentSelectedBranch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Select Branch',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose a branch to view reports for:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          
          BlocBuilder<BranchBloc, BranchState>(
            builder: (context, state) {
              if (state is BranchLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }
              
              if (state is BranchError) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600]),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load branches',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<BranchBloc>().add(LoadBranches());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              if (state is BranchesLoaded || state is BranchSelected) {
                final branches = state is BranchesLoaded 
                    ? state.branches 
                    : (state as BranchSelected).branches;
                
                // Use the passed currentSelectedBranch or get from state
                final selectedBranch = currentSelectedBranch ?? 
                    (state is BranchSelected ? state.selectedBranch : null);
                
                if (branches.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.business_outlined, 
                             size: 48, 
                             color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No branches found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Contact your administrator',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  children: branches
                      .map((branch) => _buildBranchCard(
                            context,
                            branch,
                            selectedBranch?.id == branch.id,
                          ))
                      .toList(),
                );
              }
              
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(BuildContext context, BranchModel branch, bool isSelected) {
    print('Building branch card for ${branch.name} - Selected: $isSelected');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            print('Branch card tapped: ${branch.name} (ID: ${branch.id})');
            context.read<BranchBloc>().add(SelectBranch(branch));
            onBranchSelected(branch);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected 
                  ? AppTheme.primaryColor.withOpacity(0.05) 
                  : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryColor 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : const Color(0xFF1F2937),
                        ),
                      ),
                      if (branch.address != null && branch.address!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          branch.address!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${_formatDate(branch.createdAt)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected) ...[
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr; // Return original string if parsing fails
    }
  }
}