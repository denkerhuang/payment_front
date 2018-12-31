import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/payment.dart';
import '../models/user.dart';

class ConnectedPaymentsModel extends Model {
  List<Product> _products = [];
  String _selProductId;
  // User _authenticatedUser;
  User _authenticatedUser = User(
      userId: 'fdalsdfasf', email: 'jimmy.liao@gmail.com', password: 'password');
  bool _isLoading = false;
}

//local test
// final String baseAPI = 'http://localhost:5000/mytest-d5fbd/us-central1';
//dev
final String baseAPI = 'https://us-central1-mytest-d5fbd.cloudfunctions.net';

class PaymentsModel extends ConnectedPaymentsModel {
  final String paymentEP = baseAPI + '/payment';
  final String userEP = baseAPI + '/user';
  List<Payment> _payments = [];
  List<User> _users = [];
  double totalAmount;
  String receiver = '';

  bool _showFavorites = false;

  void setReceiver(receiver) {
    this.receiver = receiver;
  }

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Payment> get allPayments {
    return List.from(_payments);
  }

  List<User> get displayedUsers {
    return List.from(_users);
  }

  List<Payment> get displayedPayments {
    return List.from(_payments);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addPayment(String payer, String receiver, double price) async {
    _payments = [];
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> paymentData = {
      // 'userId': _authenticatedUser.id
      'Payer': _authenticatedUser.email,
      'Receiver': receiver,
      'Amount': price,
    };
    try {
      final http.Response response = await http.post(paymentEP,
          body: json.encode(paymentData),
          headers: {"Content-Type": "application/json"});
      // await http.post(paymentAPI, body: productData);
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': price,
      // 'userEmail': selectedProduct.userEmail,
      // 'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-products.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: image,
        price: price,
        // userEmail: selectedProduct.userEmail,
        // userId: selectedProduct.userId
      );
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchUsers() {
    _users = [];
    _isLoading = true;
    notifyListeners();
    return http.get(userEP).then<Null>((http.Response response) {
      final List<dynamic> userList = json.decode(response.body);

      if (userList == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print(userList.length);

      for (var i = 0; i < userList.length; i++) {
        // exclude self
        if (_authenticatedUser.email != userList[i]['Email']) {
          _users.add(
              User(userId: userList[i]['UserId'], email: userList[i]['Email']));
        }
      }

      // _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchPayments() {
    _payments = [];
    totalAmount = 0.0;
    _isLoading = true;
    notifyListeners();
    String getUrl = paymentEP + '?Payer=' + _authenticatedUser.email;
    if (receiver != '') {
      getUrl += '&Receiver=' + receiver;
    }
    print('getUrl: ' + getUrl);
    return http.get(getUrl).then<Null>((http.Response response) {
      final List<dynamic> paymentList = json.decode(response.body);

      if (paymentList == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print(paymentList.length);

      for (var i = 0; i < paymentList.length; i++) {
        _payments.add(Payment(
            paymentId: paymentList[i]['PaymentId'],
            receiver: paymentList[i]['Receiver'],
            amount: paymentList[i]['Amount'].toDouble()));
        totalAmount += paymentList[i]['Amount'].toDouble();
        // fetchedProductList.add(payment);
      }

      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      receiver = '';
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        // userEmail: selectedProduct.userEmail,
        // userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedPaymentsModel {
  void login(String email, String password) {
    _authenticatedUser =
        User(userId: 'fdalsdfasf', email: email, password: password);
  }
}

class UtilityModel extends ConnectedPaymentsModel {
  bool get isLoading {
    return _isLoading;
  }
}
