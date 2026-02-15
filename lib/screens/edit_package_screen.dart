import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/side_navigation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import '../services/package_service.dart';
import '../models/package.dart';

class EditPackageScreen extends StatefulWidget {
  final Package package;
  const EditPackageScreen({Key? key, required this.package}) : super(key: key);

  @override
  State<EditPackageScreen> createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends State<EditPackageScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedNavIndex = 2;
  
  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  late TextEditingController _availableSeatsController;
  late TextEditingController _discountController;
  late TextEditingController _provinceController;
  late TextEditingController _departureCityController;
  late TextEditingController _notIncludedController;
  
  // Checkboxes
  bool _includeTransport = false;
  bool _includeAccommodation = false;
  bool _includeMeals = false;
  bool _isFeatured = false;
  bool _hasDiscount = false;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.package.title);
    _descriptionController = TextEditingController(text: widget.package.description);
    _locationController = TextEditingController(text: widget.package.location);
    _priceController = TextEditingController(text: widget.package.price.toString());
    _durationController = TextEditingController(text: widget.package.duration);
    _availableSeatsController = TextEditingController(text: widget.package.availableSeats.toString());
    _discountController = TextEditingController();
    _provinceController = TextEditingController();
    _departureCityController = TextEditingController();
    _notIncludedController = TextEditingController();
  }

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
                        'Edit Package',
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
                                      text: 'Save Changes',
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await PackageService.updatePackage(
        widget.package.id,
        {
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'location': _locationController.text.trim(),
          'price': double.tryParse(_priceController.text) ?? 0,
          'duration': _durationController.text.trim(),
          'availableSeats': int.tryParse(_availableSeatsController.text) ?? 0,
        },
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Package updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update package. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
