import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mart_erp/auth/views/signin_view.dart';
import 'package:mart_erp/common/utils/image_file_picker_utils.dart';
import 'package:mart_erp/common/utils/location_utils.dart';
import 'package:mart_erp/common/widgets/date_picker_widget.dart';
import 'package:mart_erp/features/customer/add_customer_model.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_bloc.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_event.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_state.dart';
import 'package:mart_erp/features/customer/widget/customer_creation_error.dart';
import 'package:mart_erp/features/customer/widget/process_starte_widget.dart';
import 'package:mart_erp/otp/model/otp_genetate_model.dart';
import 'package:mart_erp/otp/screen/otp_verification_screen.dart';
import 'package:mart_erp/otp/service/otp_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({required this.uniqueId, super.key});
  final String uniqueId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddCustomerBloc(),
      child: AddCustomerView(uniqueId: uniqueId),
    );
  }
}

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({required this.uniqueId, super.key});
  final String uniqueId;

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _partyController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panVatController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController(
    text: '0',
  );
  final TextEditingController _longitudeController = TextEditingController(
    text: '0',
  );
  final TextEditingController _nearestLocationController =
      TextEditingController();
  final TextEditingController _dobTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      if (kDebugMode) {
        _populateDemoData();
      }
    });
  }

  void _populateDemoData() {
    _partyController.text = 'Demo Customer';
    _mobileNoController.text = '9841234567';
    _emailController.text = 'rukesh.gwachha@dynamic.net.np';
    _panVatController.text = '123456789';
    _addressController.text = 'Demo Address, Kathmandu, Nepal';
    _nearestLocationController.text = 'Demo Location';
    _dobTextController.text = '1990-01-01';
  }

  Future<void> _getCurrentLocation() async {
    try {
      var position = await LocationUtils.getUserCurrentLocation();
      if (mounted) {
        _latitudeController.text = position?.latitude.toStringAsFixed(6) ?? '0';
        _longitudeController.text =
            position?.longitude.toStringAsFixed(6) ?? '0';
        context.read<AddCustomerBloc>().add(const AddCustomerSetReady());
      }
    } catch (e) {
      debugPrint('Location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
        context.read<AddCustomerBloc>().add(const AddCustomerSetReady());
      }
    }
  }

  @override
  void dispose() {
    _partyController.dispose();
    _mobileNoController.dispose();
    _emailController.dispose();
    _panVatController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _dobTextController.dispose();
    _nearestLocationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_latitudeController.text == '0') {
      EasyLoading.showError('Please enable location services');
      return;
    }

    try {
      EasyLoading.show(status: 'Registering customer...');

      var customer = AddCustomerModel(
        uniqueId: widget.uniqueId,
        name: _partyController.text.trim(),
        mobileNo: _mobileNoController.text.trim(),
        emailId: _emailController.text.trim(),
        panVatNo: _panVatController.text.trim(),
        address: _addressController.text.trim(),
        lat: _latitudeController.text,
        lon: _longitudeController.text,
        location: _nearestLocationController.text.trim(),
        dob: _dobTextController.text,
      );

      final bloc = context.read<AddCustomerBloc>();
      final state = bloc.state;
      if (state.pickedImages.isNotEmpty) {
        customer = customer.copyWith(
          image: state.pickedImages.last.path,
          imagePath: state.pickedImages.last.path,
        );
      }

      var otpRequestData = OtpGenerateModel(
        emailId: customer.emailId ?? '',
        hashData: customer.tokenhashData,
        mobileNo: customer.mobileNo,
        uniqueId: widget.uniqueId,
        addCustomerModel: customer,
        refId: widget.uniqueId,
      );

      var data = await OtpService.generateOtp(otpData: otpRequestData);

      if (mounted) EasyLoading.dismiss();

      if (data.isSuccess ?? false) {
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                otpGenetateData: otpRequestData,
                onVerificationSuccess: () async {
                  _resetForm();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Signin()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
          );
        }
      } else {
        EasyLoading.showError(
          data.responseMsg ?? 'Failed to register customer',
        );
        _resetForm();
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Registration error: $e');
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ErrorScreen()),
        );
      }
    }
  }

  void _resetForm() {
    _partyController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _panVatController.clear();
    _addressController.clear();
    _latitudeController.text = '0';
    _longitudeController.text = '0';
    _nearestLocationController.clear();
    context.read<AddCustomerBloc>().add(const AddCustomerImagesCleared());
    _formKey.currentState?.reset();
    context.read<AddCustomerBloc>().add(const AddCustomerReset());
  }

  Future<void> _pickImage() async {
    try {
      var status = await Permission.camera.request();
      if (status.isDenied) {
        EasyLoading.showError('Camera permission required');
        return;
      }

      var image = await ImageFilePickerUtils.getImageOnly(context: context);
      if (image != null && mounted) {
        context.read<AddCustomerBloc>().add(AddCustomerImagePicked(image));
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      EasyLoading.showError('Failed to pick image');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocBuilder<AddCustomerBloc, AddCustomerState>(
        builder: (context, customerState) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 20.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Registration',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.indigo[800]!, Colors.indigo[600]!]
                            : [Colors.blue[600]!, Colors.lightBlue[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: CustomerProcessingWidget(
                  onRetry: () => context.read<AddCustomerBloc>().add(
                    const AddCustomerReset(),
                  ),
                  message: customerState.errorMessage ?? '',
                  navigate: () {},
                  customerstate: customerState,
                  readyContent: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProfilePictureSection(context, customerState),
                          const SizedBox(height: 32),
                          _buildCustomerForm(theme),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfilePictureSection(
    BuildContext context,
    AddCustomerState state,
  ) {
    final pickedImages = state.pickedImages;
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  image: pickedImages.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(pickedImages.last),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: pickedImages.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: _pickImage,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          pickedImages.isEmpty
              ? 'Add Customer Photo (Optional)'
              : 'Tap to change photo',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerForm(ThemeData theme) {
    return Column(
      children: [
        _buildTextField(
          controller: _partyController,
          label: 'Customer Name',
          icon: Icons.person_outline,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter customer name'
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _mobileNoController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          label: 'Mobile Number',
          icon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Please enter mobile number';
            if (value.length != 10)
              return 'Please enter a valid 10-digit number';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          controller: _dobTextController,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            prefixIcon: Icon(
              Icons.calendar_month,
              color: theme.colorScheme.primary,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter valid Date' : null,
          onTap: () async {
            DateTime? date = await DateAndTimePicker.showCustomDatePicker(
              context,
              lastDate: DateTime.now(),
            );
            if (date != null) {
              _dobTextController.text = date.format();
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter email';
            if (value.isNotEmpty) {
              var emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value))
                return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _panVatController,
          label: 'PAN/VAT Number',
          icon: Icons.credit_card_outlined,
          inputFormatters: [LengthLimitingTextInputFormatter(9)],
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length != 9) {
              return 'Please enter a valid 9-digit number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _addressController,
          label: 'Full Address',
          icon: Icons.home_outlined,
          maxLines: 2,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter address' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nearestLocationController,
          label: 'Nearest Landmark',
          icon: Icons.location_on_outlined,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
