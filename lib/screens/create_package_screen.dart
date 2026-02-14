import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/side_navigation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import '../services/package_service.dart';

class CreatePackageScreen extends StatefulWidget {
  const CreatePackageScreen({Key? key}) : super(key: key);

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedNavIndex = 2;
  
  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _availableSeatsController = TextEditingController();
  final _discountController = TextEditingController();
  final _provinceController = TextEditingController();
  final _departureCityController = TextEditingController();
  final _notIncludedController = TextEditingController();
  
  // Checkboxes
  bool _includeTransport = false;
  bool _includeAccommodation = false;
  bool _includeMeals = false;
  bool _isFeatured = false;
  bool _hasDiscount = false;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _availableSeatsController.dispose();
    _discountController.dispose();
    _provinceController.dispose();
    _departureCityController.dispose();
    _notIncludedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Side Navigation
          SideNavigation(
            selectedIndex: _selectedNavIndex,
            onItemSelected: (index) {
              setState(() => _selectedNavIndex = index);
            },
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Create New Package',
                        style: AppTextStyles.headingMedium,
                      ),
                    ],
                  ),
                ),
                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Upload Thumbnail
                              _buildSection(
                                'Package Thumbnail',
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(AppDimensions.radius),
                                    border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 50,
                                          color: AppColors.textTertiary,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Click to upload image',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'PNG, JPG up to 5MB',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Basic Info
                              _buildSection(
                                'Basic Information',
                                Column(
                                  children: [
                                    CustomInput(
                                      label: 'Package Title',
                                      controller: _titleController,
                                      hint: 'e.g., 2-Day Nathia Gali Adventure',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter package title';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    CustomInput(
                                      label: 'Description',
                                      controller: _descriptionController,
                                      hint: 'Describe your package...',
                                      maxLines: 4,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter description';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomInput(
                                            label: 'Location',
                                            controller: _locationController,
                                            hint: 'e.g., Nathia Gali',
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter location';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: CustomInput(
                                            label: 'Price (PKR)',
                                            controller: _priceController,
                                            hint: 'e.g., 15000',
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter price';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomInput(
                                            label: 'Duration',
                                            controller: _durationController,
                                            hint: 'e.g., 3 Days, 2 Nights',
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter duration';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: CustomInput(
                                            label: 'Available Seats',
                                            controller: _availableSeatsController,
                                            hint: 'e.g., 20',
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter seats';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Includes
                              _buildSection(
                                'What\'s Included',
                                Column(
                                  children: [
                                    _buildCheckbox('Transport', _includeTransport, (value) {
                                      setState(() => _includeTransport = value!);
                                    }),
                                    _buildCheckbox('Accommodation', _includeAccommodation, (value) {
                                      setState(() => _includeAccommodation = value!);
                                    }),
                                    _buildCheckbox('Meals', _includeMeals, (value) {
                                      setState(() => _includeMeals = value!);
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Highlight Options
                              _buildSection(
                                'Highlight Options',
                                Column(
                                  children: [
                                    _buildCheckbox('Featured Package', _isFeatured, (value) {
                                      setState(() => _isFeatured = value!);
                                    }),
                                    _buildCheckbox('Discount Available', _hasDiscount, (value) {
                                      setState(() => _hasDiscount = value!);
                                    }),
                                    if (_hasDiscount) ...[
                                      const SizedBox(height: 16),
                                      CustomInput(
                                        label: 'Discount Percentage',
                                        controller: _discountController,
                                        hint: 'e.g., 30',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Additional Details
                              _buildSection(
                                'Additional Details',
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomInput(
                                            label: 'Province',
                                            controller: _provinceController,
                                            hint: 'e.g., Khyber Pakhtunkhwa',
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: CustomInput(
                                            label: 'Departure City',
                                            controller: _departureCityController,
                                            hint: 'e.g., Islamabad',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    CustomInput(
                                      label: 'What\'s Not Included',
                                      controller: _notIncludedController,
                                      hint: 'e.g., Personal expenses, Travel insurance',
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Submit Button
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        side: const BorderSide(color: AppColors.border),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(AppDimensions.radius),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: CustomButton(
                                      text: 'Create Package',
                                      onPressed: _handleSubmit,
                                      isLoading: _isLoading,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headingSmall.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await PackageService.createPackage(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        duration: _durationController.text.trim(),
        availableSeats: int.tryParse(_availableSeatsController.text) ?? 0,
        // image can be added if upload is implemented
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Package created successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create package. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
