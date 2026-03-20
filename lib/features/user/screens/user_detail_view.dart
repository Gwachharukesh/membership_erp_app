import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/user_detail_bloc.dart';
import '../bloc/user_detail_event.dart';
import '../bloc/user_detail_state.dart';
import '../widgets/api_error_widget.dart';

/// Example widget showing how to fetch and display user details with error handling
class UserDetailView extends StatefulWidget {
  final int userId;

  const UserDetailView({super.key, required this.userId});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  late UserDetailBloc _userDetailBloc;

  @override
  void initState() {
    super.initState();
    _userDetailBloc = context.read<UserDetailBloc>();
    _fetchUserDetail();
  }

  void _fetchUserDetail() {
    _userDetailBloc.add(FetchUserDetail(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDetailBloc, UserDetailState>(
      listener: (context, state) {
        if (state.status == UserDetailStatus.error) {
          // Show error dialog with retry option
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ApiErrorWidget(
              errorMessage: state.errorMessage ?? 'Unknown error occurred',
              isNetworkError: state.isNetworkError,
              onRetry: _fetchUserDetail,
              onDismiss: () => Navigator.pop(context),
              showRetryButton: true,
            ),
          );
        }
      },
      child: BlocBuilder<UserDetailBloc, UserDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('User Details'), elevation: 0),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(UserDetailState state) {
    return switch (state.status) {
      UserDetailStatus.loading => _buildLoadingState(),
      UserDetailStatus.success => _buildSuccessState(state),
      UserDetailStatus.error => _buildErrorState(state),
      _ => _buildInitialState(),
    };
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 20.w, color: Colors.grey.shade300),
          SizedBox(height: 2.w),
          Text(
            'Ready to load user details',
            style: TextStyle(fontSize: 4.w, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4.w),
          ElevatedButton(
            onPressed: _fetchUserDetail,
            child: const Text('Load Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 2.w),
          Text('Fetching user details...', style: TextStyle(fontSize: 4.w)),
        ],
      ),
    );
  }

  Widget _buildSuccessState(UserDetailState state) {
    final userDetail = state.userDetail;
    if (userDetail == null) {
      return const Center(child: Text('No user data available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User ID Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ID: ${userDetail.userId}',
                      style: TextStyle(
                        fontSize: 3.w,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.w),

                  // Name
                  _buildDetailRow('Name', userDetail.name ?? 'N/A'),
                  SizedBox(height: 1.5.w),

                  // Username
                  _buildDetailRow('Username', userDetail.userName ?? 'N/A'),
                  SizedBox(height: 1.5.w),

                  // Group
                  _buildDetailRow('Group', userDetail.groupName ?? 'N/A'),
                  SizedBox(height: 1.5.w),

                  // Designation
                  _buildDetailRow(
                    'Designation',
                    userDetail.designation ?? 'N/A',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.w),

          // Contact Info Card
          _buildSectionCard(
            title: 'Contact Information',
            children: [
              _buildDetailRow('Mobile', userDetail.mobileNo ?? 'N/A'),
              SizedBox(height: 1.5.w),
              _buildDetailRow('Email', userDetail.emailId ?? 'N/A'),
            ],
          ),
          SizedBox(height: 3.w),

          // Company Info Card
          _buildSectionCard(
            title: 'Company Details',
            children: [
              _buildDetailRow('Company', userDetail.companyName ?? 'N/A'),
              SizedBox(height: 1.5.w),
              _buildDetailRow('Address', userDetail.companyAddress ?? 'N/A'),
              SizedBox(height: 1.5.w),
              _buildDetailRow('Branch', userDetail.branch ?? 'N/A'),
            ],
          ),
          SizedBox(height: 3.w),

          // Location Info Card
          if (userDetail.address != null && userDetail.address!.isNotEmpty)
            _buildSectionCard(
              title: 'Location',
              children: [_buildDetailRow('Address', userDetail.address!)],
            ),

          SizedBox(height: 2.w),

          // Refresh Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _fetchUserDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Details'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(UserDetailState state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.isNetworkError
                  ? Icons.signal_cellular_off
                  : Icons.error_outline,
              size: 20.w,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 2.w),
            Text(
              state.isNetworkError ? 'Network Error' : 'Error',
              style: TextStyle(
                fontSize: 5.w,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 2.w),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                state.errorMessage ?? 'Unknown error occurred',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 3.8.w,
                  color: Colors.red.shade700,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 4.w),
            ElevatedButton.icon(
              onPressed: _fetchUserDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
              ),
            ),
            SizedBox(height: 2.w),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 3.5.w,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 3.5.w,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 4.2.w,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 2.w),
            Divider(height: 0, thickness: 0.5),
            SizedBox(height: 2.w),
            ...children,
          ],
        ),
      ),
    );
  }
}
