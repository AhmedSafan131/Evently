import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/model/event.dart';

class FirebaseUtils {
  static CollectionReference<Event> getEventsCollection() {
    return FirebaseFirestore.instance
        .collection(Event.collectionName)
        .withConverter<Event>(
            fromFirestore: (snapshot, options) =>
                Event.fromFireStore(snapshot.data()!),
            toFirestore: (event, options) => event.toFireStore());
  }

  static Future<void> addEventToFireStore(Event event) {
    var eventsCollection = getEventsCollection();
    DocumentReference<Event> docRef = eventsCollection.doc();
    event.id = docRef.id;
    // getEventsCollection().doc().set(event);
    return docRef.set(event);
  }

  static Future<void> updateEventInFireStore(Event event) {
    var eventsCollection = getEventsCollection();
    if (event.id.isEmpty) {
      throw Exception('Event id is required for update');
    }
    return eventsCollection.doc(event.id).set(event);
  }

  static Future<void> deleteEventFromFireStore(String eventId) {
    var eventsCollection = getEventsCollection();
    return eventsCollection.doc(eventId).delete();
  }
}
