import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

   getQuestionData() async{
    return await Firestore.instance.collection("QNA").getDocuments();

  }
}