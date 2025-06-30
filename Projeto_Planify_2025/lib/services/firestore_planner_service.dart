import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart'; 
import 'package:planify/models/events_model.dart';
import 'package:planify/models/task.dart';
import 'package:planify/services/firestore_service.dart'; 
import 'package:flutter/foundation.dart'; 

class FirestorePlannerService implements FirestoreService {
  @override
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestorePlannerService({required this.userId});

  

  @override
  Stream<List<dynamic>> getEventsAndTasksForSelectedDay(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    
    
    final eventsStream = _firestore
        .collection('events') 
        .where('userId', isEqualTo: userId) 
        .where('startTime', isGreaterThanOrEqualTo: startOfDay)
        .where('startTime', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());

    final tasksStream = _firestore
        .collection('tasks') 
        .where('userId', isEqualTo: userId) 
        .where('dueDate', isGreaterThanOrEqualTo: startOfDay)
        .where('dueDate', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());

    return Rx.combineLatest2(
      eventsStream,
      tasksStream,
      (List<Event> events, List<Task> tasks) {
        return [...events, ...tasks];
      },
    );
  }

  @override
  Future<void> updateEventCompletion(String eventId, bool isCompleted) async {
    await _firestore
        .collection('events') 
        .doc(eventId)
        .update({'isCompleted': isCompleted});
    debugPrint("DEBUG: Evento com ID '$eventId' status atualizado para o usuário '$userId'.");
  }

  @override
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    await _firestore
        .collection('tasks') 
        .doc(taskId)
        .update({'status': isCompleted ? 'completed' : 'pending'});
    debugPrint("DEBUG: Tarefa com ID '$taskId' status atualizado para o usuário '$userId'.");
  }

  @override
  Future<void> createTask(Map<String, dynamic> taskData) async {
    
    
    try {
      await _firestore
          .collection('tasks') 
          .add(taskData);
      debugPrint('DEBUG: Tarefa adicionada com sucesso no Firestore para o usuário $userId!');
    } catch (e) {
      debugPrint('DEBUG: Erro ao adicionar tarefa no Firestore para o usuário $userId: $e');
      rethrow;
    }
  }

  
  
  
  
}
