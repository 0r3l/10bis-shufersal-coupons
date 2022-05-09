import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tenbis_shufersal_coupons/models/family-group.dart';

class FirestoreCollections {
  static String get coupons {
    return 'coupons';
  }

  static String get families {
    return 'families';
  }

  static String get familyUsers {
    return 'familyUsers';
  }

  static String get gissCatalog {
    return 'gissCatalog';
  }

  static String get settings {
    return 'settings';
  }
}

class FirestoreService {
  static Future archive(
      String collectionFrom, FamilyGroup familyGroup, String id) async {
    final originDocRef =
        FirebaseFirestore.instance.collection(collectionFrom).doc(id);

    final destinationDocRef =
        FirebaseFirestore.instance.collection('$collectionFrom-deleted').doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final originData = (await transaction.get(originDocRef)).data();
      transaction.delete(originDocRef);
      if (originData != null) {
        originData.update('deletedAt', (_) => DateTime.now());
        transaction.set(destinationDocRef, originData);
      }
    });
  }

  static Future update(String collection, FamilyGroup familyGroup, String id,
      Map<String, dynamic> data) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collection).doc(id);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        transaction.update(docRef, data);
      }
    });
  }

  static Future<Map<String, dynamic>?> getById<T>(String collection, String id,
      [FamilyGroup? familyGroup]) async {
    final res =
        await FirebaseFirestore.instance.collection(collection).doc(id).get();
    return res.data();
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?> findDocs<T>(
      String collection, String key, T value,
      [FamilyGroup? familyGroup]) async {
    final res = await FirebaseFirestore.instance
        .collection(collection)
        .where(key, isEqualTo: value)
        .get();
    return res.docs.length > 0 ? res.docs : null;
  }

  static Future<DocumentReference<Map<String, dynamic>>> add(
      String collection, Map<String, dynamic> data,
      [FamilyGroup? familyGroup]) {
    return FirebaseFirestore.instance.collection(collection).add(data);
  }

  static Future<bool> isCollectionEmpty(
      String collection, FamilyGroup familyGroup) async {
    return (await FirebaseFirestore.instance
            .collection(collection)
            .limit(1)
            .snapshots()
            .length) ==
        0;
  }

  static Future remove(String collection, FamilyGroup familyGroup, id) {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collection).doc(id);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        transaction.delete(docRef);
      }
    });
  }

  static Future<void> batchDeleteAllDocuments(
      String collection, FamilyGroup familyGroup) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return FirebaseFirestore.instance
        .collection(collection)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }

  static Future<void> batchDeleteQueryDocuments(
      String collection, String key, String value,
      [FamilyGroup? familyGroup]) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return FirebaseFirestore.instance
        .collection(collection)
        .where(key, isEqualTo: value)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }

  static Future<void>? batchAddDocuments(
      String collection, FamilyGroup familyGroup, Iterable<dynamic> items) {
    if (items.length == 0) {
      return null;
    }
    WriteBatch batch = FirebaseFirestore.instance.batch();

    items.forEach((doc) {
      final docRef = FirebaseFirestore.instance
          .collection(collection)
          .doc(); //automatically generate unique id
      batch.set(docRef, doc);
    });
    return batch.commit();
  }
}
