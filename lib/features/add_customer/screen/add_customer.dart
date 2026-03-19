import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mart_erp/auth/views/signin_view.dart';
import 'package:mart_erp/common/image_pick/utils/image_file_picker_utils.dart';
import 'package:mart_erp/common/utils/location_utils.dart';
import 'package:mart_erp/features/add_customer/bloc/add_customer_bloc.dart';
import 'package:mart_erp/features/add_customer/bloc/add_customer_event.dart';
import 'package:mart_erp/features/add_customer/bloc/add_customer_state.dart';
import 'package:mart_erp/features/add_customer/screen/process_starte_widget.dart';
import 'package:mart_erp/features/add_customer/widget/customer_creation_error.dart';
import 'package:mart_erp/features/otp/model/otp_genetate_model.dart';
import 'package:mart_erp/features/otp/screen/otp_verification_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../otp/service/otp_service.dart';
import '../model/add_customer_model.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({required this.uniqueId, super.key});
  final String uniqueId;

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late AddCustomerBloc _addCustomerBloc;
  /*
  final _emailController = kDebugMode
      ? TextEditingController(text: 'rukesh.gwachha@dynamic.net.np')
      : TextEditingController();
  final _panVatController = kDebugMode
      ? TextEditingController(text: '123456789')
      : TextEditingController();
  final _addressController = kDebugMode
      ? TextEditingController(text: 'address')
      : TextEditingController();
  final _latitudeController = kDebugMode
      ? TextEditingController(text: '0.0')
      : TextEditingController(text: '0');
  final _longitudeController = kDebugMode
      ? TextEditingController(text: '0.0')
      : TextEditingController(text: '0');
  final _nearestLocationController = kDebugMode
      ? TextEditingController(text: 'address')
      : TextEditingController();
  final _dobTextController = kDebugMode
      ? TextEditingController(text: '2022/08/07')
      : TextEditingController();
      */

  final TextEditingController _partyController = kDebugMode
      ? TextEditingController(text: 'RUkesh')
      : TextEditingController();
  final TextEditingController _mobileNoController = kDebugMode
      ? TextEditingController(text: '9860918194')
      : TextEditingController();
  final TextEditingController _emailController = kDebugMode
      ? TextEditingController(text: 'rukesh.gwachha@dynamic.net.np')
      : TextEditingController();
  final TextEditingController _panVatController = kDebugMode
      ? TextEditingController(text: '123456789')
      : TextEditingController();
  final TextEditingController _addressController = kDebugMode
      ? TextEditingController(text: 'address')
      : TextEditingController();
  final TextEditingController _latitudeController = TextEditingController(
    text: LocationUtils.defaultLatitude.toString(),
  );
  final TextEditingController _longitudeController = TextEditingController(
    text: LocationUtils.defaultLongitude.toString(),
  );
  final TextEditingController _nearestLocationController =
      TextEditingController();
  final TextEditingController _dobTextController = kDebugMode
      ? TextEditingController(text: '2026-03-19')
      : TextEditingController();
  @override
  void initState() {
    super.initState();
    _addCustomerBloc = AddCustomerBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCurrentLocation());
  }

  Future<void> _getCurrentLocation() async {
    try {
      final coordinates = await LocationUtils.getLocationCoordinates();
      _latitudeController.text = coordinates['latitude'].toString();
      _longitudeController.text = coordinates['longitude'].toString();
    } catch (e) {
      debugPrint('Location error: $e');
      _latitudeController.text = LocationUtils.defaultLatitude.toString();
      _longitudeController.text = LocationUtils.defaultLongitude.toString();
    } finally {
      _addCustomerBloc.add(SetAddCustomerReady());
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
    _addCustomerBloc.close();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

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

      var otpRequestData = OtpGenerateModel(
        emailId: customer.emailId ?? '',
        hashData: customer.tokenhashData,
        mobileNo: customer.mobileNo,
        uniqueId: widget.uniqueId,
        addCustomerModel: customer,
        refId: widget.uniqueId,
      );

      var data = await OtpService.generateOtp(otpData: otpRequestData);

      if (data.isSuccess ?? false) {
        EasyLoading.dismiss();
        // Navigate to OTP screen and then to login after successful verification
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              otpGenetateData: otpRequestData,
              onVerificationSuccess: () async {
                _resetForm();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Signin()),
                  (route) => false,
                );
              },
            ),
          ),
        );
      } else {
        EasyLoading.showError(
          data.responseMsg ?? 'Failed to register customer',
        );
        _resetForm();
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Registration error: $e');
      // Navigate to error screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorScreen()),
      );
    }
  }

  void _resetForm() {
    // Reset all controllers
    _partyController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _panVatController.clear();
    _addressController.clear();
    _latitudeController.text = LocationUtils.defaultLatitude.toString();
    _longitudeController.text = LocationUtils.defaultLongitude.toString();
    _nearestLocationController.clear();

    // Reset image
    _addCustomerBloc.add(ClearCustomerImages());

    // Reset form state
    _formKey.currentState?.reset();

    // Reset customer state
    _addCustomerBloc.add(ResetAddCustomerState());
  }

  Future<void> _pickImage() async {
    try {
      var status = await Permission.camera.request();
      if (status.isDenied) {
        EasyLoading.showError('Camera permission required');
        return;
      }

      var image = await ImageFilePickerUtils.getImageOnly(context: context);
      if (image != null) {
        _addCustomerBloc.add(AddCustomerImage(image));
        setState(() {});
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

    return BlocProvider(
      create: (context) => _addCustomerBloc,
      child: BlocBuilder<AddCustomerBloc, AddCustomerState>(
        builder: (context, state) {
          return Scaffold(
            body: CustomScrollView(
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
                  actions: const [],
                ),
                SliverToBoxAdapter(
                  child: CustomerProcessingWidget(
                    onRetry: () => context.read<AddCustomerBloc>().add(
                      ResetAddCustomerState(),
                    ),
                    message: state.errorMessage,
                    navigate: () {},
                    customerstate: state,
                    readyContent: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildProfilePictureSection(
                                context,
                                state.pickedImages,
                              ),
                              const SizedBox(height: 32),
                              _buildCustomerForm(theme),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: _submitForm,
                                child: Text('Register'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       child: Form(
                //         key: _formKey,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.stretch,
                //           children: [
                //             _buildProfilePictureSection(context, imageProvider),
                //             const SizedBox(height: 32),
                //             _buildCustomerForm(theme),
                //             const SizedBox(height: 40),
                //             _buildSubmitButton(theme),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePictureSection(
    BuildContext context,
    List<dynamic> pickedImages,
  ) {
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter customer name';
            }
            return null;
          },
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
            if (value == null || value.isEmpty) {
              return 'Please enter mobile number';
            }

            if (value.length != 10) {
              return 'Please enter a valid 10-digit number';
            }
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
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter valid Date';
            }
            return null;
          },
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              _dobTextController.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
        ),
        const SizedBox(height: 16),
        /*
         _buildTextField(
          controller: _partyController,
          label: 'Customer Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter customer name';
            }
            return null;
          },
        ),
        
         */
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter customer name';
            }

            if (value.isNotEmpty) {
              var emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
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
            if (value != null && value.isNotEmpty) {
              if (value.length != 9) {
                return 'Please enter a valid 9-digit number';
              }
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
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
    int? maxLines = 1,
    bool? readOnly,
  }) {
    return TextFormField(
      readOnly: readOnly ?? false,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
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
