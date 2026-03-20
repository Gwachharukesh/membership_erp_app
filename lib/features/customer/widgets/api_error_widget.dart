import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ApiErrorWidget extends StatelessWidget {
  final String errorMessage;
  final bool isNetworkError;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool showRetryButton;

  const ApiErrorWidget({
    super.key,
    required this.errorMessage,
    this.isNetworkError = false,
    this.onRetry,
    this.onDismiss,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNetworkError ? Icons.signal_cellular_off : Icons.error,
                color: Colors.red.shade600,
                size: 12.w,
              ),
            ),
            SizedBox(height: 3.w),

            // Error Title
            Text(
              isNetworkError ? 'Network Error' : 'Error',
              style: TextStyle(
                fontSize: 5.w,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 2.w),

            // Error Message
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 3.8.w,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 4.w),

            // Action Buttons
            Row(
              children: [
                // Dismiss Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDismiss ?? () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                    ),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        fontSize: 3.8.w,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),

                // Retry Button (if enabled)
                if (showRetryButton && onRetry != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onRetry?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.w),
                        elevation: 0,
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 3.8.w,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Network error help text
            if (isNetworkError) ...[
              SizedBox(height: 2.w),
              Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 3.2.w,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Snackbar version of error display
void showApiErrorSnackbar(
  BuildContext context, {
  required String message,
  bool isNetworkError = false,
  int durationSeconds = 5,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isNetworkError ? Icons.signal_cellular_off : Icons.error,
            color: Colors.white,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 3.5.w)),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade600,
      duration: Duration(seconds: durationSeconds),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(2.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

/// Bottom sheet version of error display
void showApiErrorBottomSheet(
  BuildContext context, {
  required String errorMessage,
  bool isNetworkError = false,
  VoidCallback? onRetry,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.8.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 3.w),
          Icon(
            isNetworkError ? Icons.signal_cellular_off : Icons.error,
            color: Colors.red.shade600,
            size: 15.w,
          ),
          SizedBox(height: 2.w),
          Text(
            isNetworkError ? 'Network Error' : 'Error',
            style: TextStyle(
              fontSize: 5.w,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 3.8.w,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                  ),
                  child: Text('Dismiss', style: TextStyle(fontSize: 3.8.w)),
                ),
              ),
              if (onRetry != null) ...[
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRetry.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 3.8.w,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}
