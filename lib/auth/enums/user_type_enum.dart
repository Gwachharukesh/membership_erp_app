
import '../../config/routes/routes.dart';

enum UserRole {
  dealerIncharge(1, 'Dealer_Incharge'), //mean salesman
  salesOfficer(2, ' Sales_Officer'),
  asm(3, 'ASM'),
  rsm(4, 'RSM'), // dealer
  nsm(5, 'NSM'),
  salesDirector(6, 'Sales_Director'),
  managingDirector(7, 'Managing_Director');

//Sales Superv visor
  const UserRole(this.id, this.name);
  final int id;
  final String name;
}

enum UserType {
  systemuser('SYSTEMUSER', 1),
  member('MEMBER', 2),
  admin('Admin', 1),

  unknown(null, 0),
  all(null, 1);

  const UserType(this.title, this.id);
  final String? title;
  final int? id;
}

extension UserTypeExtension on UserType {
  /// get default route for user while logged in
  String getRoute() {
    switch (this) {
      case UserType.systemuser:
        return RouteHelper.dashboardView;
      case UserType.member:
        return RouteHelper.dashboardView;
      default:
        return RouteHelper.signin;
    }
  }
}

extension UserArgument on UserType {
  /// get default route for user while logged in
  Object getArgument() {
    switch (this) {
      case UserType.systemuser:
        return true;
      case UserType.member:
        return true;

      case UserType.unknown:
      default:
        return true;
    }
  }
}

// class UserTypeModel {
//   UserTypeModel({required this.id, required this.text});

//   factory UserTypeModel.fromJson(Map<String, dynamic> json) => UserTypeModel(
//         id: json['id'],
//         text: json['Text'],
//       );
//   final int id;
//   final String text;
// }

// final selectedUserTypeProvider = StateProvider<UserType?>((ref) => null);

// final userTypeFutureProvider = FutureProvider<List<UserTypeModel>>((ref) async {
//   var response = await dioClient.get('/StaticValues/GetUserTypes');

//   if (response.statusCode == 200) {
//     return (response.data as List)
//         .map((e) => UserTypeModel.fromJson(e))
//         .toList();
//   } else {
//     return [
//       {
//         'Id': 1,
//         'Text': 'SYSTEMUSER',
//         'id': 1,
//         'text': 'SYSTEMUSER',
//         'IdStr': null,
//       },
//       {
//         'Id': 2,
//         'Text': 'DEALER',
//         'id': 2,
//         'text': 'DEALER',
//         'IdStr': null,
//       },
//       {
//         'Id': 3,
//         'Text': 'SALESMAN',
//         'id': 3,
//         'text': 'SALESMAN',
//         'IdStr': null,
//       },
//       {
//         'Id': 4,
//         'Text': 'EMPLOYEE',
//         'id': 4,
//         'text': 'EMPLOYEE',
//         'IdStr': null,
//       }
//     ].map(UserTypeModel.fromJson).toList();
//   }
// });

// class UserTypeDropdown extends ConsumerWidget {
//   const UserTypeDropdown({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var selectedUserType = ref.watch(selectedUserTypeProvider);
//     var userTypeLists =
//         ref.watch(userTypeFutureProvider); // Watch the provider for changes

//     return userTypeLists.when(
//       data: (list) => DropdownButtonFormField<UserType?>(
//         value: selectedUserType,
//         hint: const Text('-- Select an option --'), // Nullable option
//         items: [
//           const DropdownMenuItem<UserType?>(
//             child: Text('None'), // Option for null selection
//           ),
//           ...list.map(
//             (userType) => DropdownMenuItem<UserType?>(
//               value: selectedUserType,
//               child: Text(userType.text),
//             ),
//           ),
//         ],
//         onChanged: (UserType? newValue) {
//           ref.read(selectedUserTypeProvider.notifier).state =
//               newValue; // Update state using notifier
//         },
//         decoration: const InputDecoration(
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//       error: (error, stackTrace) => const Text(''),
//       loading: () => const SizedBox(),
//     );
//   }
// }
