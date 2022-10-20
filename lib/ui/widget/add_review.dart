import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

class AddReview extends StatefulWidget {
  final String restaurantId;

  const AddReview({super.key, required this.restaurantId});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  TextEditingController nameTec = TextEditingController();

  TextEditingController reviewTec = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameTec.dispose();
    reviewTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black26,
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              controller: nameTec,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input your name !';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Write your review...',
              ),
              maxLines: 3,
              controller: reviewTec,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input your review !';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    CustomerReview customerReview = CustomerReview(
                      name: nameTec.text,
                      review: reviewTec.text,
                      date: '',
                    );
                    Provider.of<RestaurantProvider>(context, listen: false)
                        .addUserReview(customerReview, widget.restaurantId);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Sumbit Review',
                  style: TextStyle(color: greenSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
