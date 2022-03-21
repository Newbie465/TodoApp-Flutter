class userModel {

    String? uid;
    String? email;
    String? firstName;
    String? secondName;

    userModel({this.uid, this.email, this.firstName, this.secondName, todos});
    
    factory userModel.fromMap(map){
      return userModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],

      );
      
    }

    Map<String, dynamic> toMap(){

      return {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'secondName': secondName,
      };

    }
}