import 'package:parkspace/Screen/PaymentMethod/paypal_payment_screen.dart';
import 'package:parkspace/resources/repository/remote/api_provider.dart';
import 'package:parkspace/resources/repository/remote/remote_repository.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/services/paypal_service.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/Model/user.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: ApiProvider()),
  Provider.value(value: PaypalServices()),
];

List<SingleChildWidget> dependentServices = [
  //Services
  ProxyProvider<ApiProvider, RemoteRepository>(
    update: (context, api, remoteRepository) => RemoteRepository(api),
  ),

  ProxyProvider<RemoteRepository, UserService>(
    update: (context, remoteRepository, userService) =>
        UserService(remoteRepository),
  ),

  ProxyProvider<RemoteRepository, ParkingService>(
    update: (context, remoteRepository, parkingService) =>
        ParkingService(remoteRepository, Provider.of<UserService>(context)),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    create: (context) =>
        Provider.of<UserService>(context, listen: false).userController.stream,
  ),
];
