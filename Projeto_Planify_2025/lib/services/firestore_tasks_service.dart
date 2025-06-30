import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planify/models/task.dart';
import 'package:planify/services/firestore_service.dart'; 
import 'package:flutter/foundation.dart'; 
import 'package:rxdart/rxdart.dart'; 





class FirestoreTasksService extends FirestoreService { 
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  FirestoreTasksService({required String userId}) : super(userId: userId);

  

  @override
  Stream<List<dynamic>> getEventsAndTasksForSelectedDay(DateTime date) {
    
    
    
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _db
        .collection('artifacts')
        .doc('planify') 
        .collection('users')
        .doc(userId) 
        .collection('tasks')
        .where('dueDate', isGreaterThanOrEqualTo: startOfDay)
        .where('dueDate', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  @override
  Future<void> updateEventCompletion(String eventId, bool isCompleted) async {
    
    
    debugPrint('DEBUG: updateEventCompletion chamado no FirestoreTasksService, que é focado em tarefas. Nenhuma ação realizada para o Evento ID: $eventId.');
  }

  @override
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    
    await _db
        .collection('artifacts')
        .doc('planify')
        .collection('users')
        .doc(userId) 
        .collection('tasks')
        .doc(taskId)
        .update({'status': isCompleted ? 'completed' : 'pending'});
    debugPrint("DEBUG: Tarefa com ID '$taskId' status atualizado para o usuário '$userId'.");
  }

  

  Future<void> createUserTask({
    required String title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? time, 
    String? projectId, 
  }) async {
    final newTask = Task(
      id: '', 
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      status: 'pending',
      createdAt: DateTime.now(),
      userId: userId, 
      time: time, 
      projectId: projectId, 
    );

    debugPrint("DEBUG: Dados da tarefa sendo enviados ao Firestore: ${newTask.toFirestore()}");

    await _db
        .collection('artifacts')
        .doc('planify')
        .collection('users')
        .doc(userId) 
        .collection('tasks')
        .add(newTask.toFirestore());
    debugPrint("DEBUG: Tarefa '$title' criada para o usuário '$userId'.");
  }

  Future<List<Task>> listUserTasks({String? filter}) async {
    Query query = _db
        .collection('artifacts')
        .doc('planify')
        .collection('users')
        .doc(userId) 
        .collection('tasks');

    if (filter != null) {
      if (filter == 'concluídas') {
        query = query.where('status', isEqualTo: 'completed');
      } else if (filter == 'pendentes') {
        query = query.where('status', isEqualTo: 'pending');
      } else if (filter == 'hoje') {
        final now = DateTime.now();
        final startOfToday = DateTime(now.year, now.month, now.day);
        final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
        query = query
            .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
            .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfToday));
      } else if (filter == 'futuras') {
        final now = DateTime.now();
        final startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
        query = query.where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfTomorrow));
      }
    }

    final snapshot = await query.orderBy('createdAt', descending: true).get();
    debugPrint("DEBUG: Listando tarefas para o usuário '$userId'. Encontradas ${snapshot.docs.length}.");
    return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
  }

  Future<Task?> findTaskByTitle(String title) async {
    final snapshot = await _db
        .collection('artifacts')
        .doc('planify')
        .collection('users')
        .doc(userId) 
        .collection('tasks')
        .where('title', isEqualTo: title)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      debugPrint("DEBUG: Tarefa '$title' encontrada para o usuário '$userId'.");
      return Task.fromFirestore(snapshot.docs.first);
    }
    debugPrint("DEBUG: Tarefa '$title' NÃO encontrada para o usuário '$userId'.");
    return null;
  }

  Future<void> updateUserTask({
    required String taskId,
    String? newTitle,
    DateTime? newDueDate,
    String? newPriority,
    bool? isCompleted,
    String? newTime, 
    String? newDescription, 
    String? newProjectId, 
  }) async {
    final Map<String, dynamic> updates = {};
    if (newTitle != null) updates['title'] = newTitle;
    if (newDueDate != null) {
      updates['dueDate'] = Timestamp.fromDate(newDueDate);
    } else if (newDueDate == null && updates.containsKey('dueDate')) {
      updates['dueDate'] = FieldValue.delete(); 
    }
    if (newPriority != null) updates['priority'] = newPriority;
    if (isCompleted != null) {
      updates['status'] = isCompleted ? 'completed' : 'pending';
    }
    if (newTime != null) updates['time'] = newTime; 
    if (newDescription != null) updates['description'] = newDescription; 
    if (newProjectId != null) updates['projectId'] = newProjectId; 

    if (updates.isNotEmpty) {
      await _db
          .collection('artifacts')
          .doc('planify')
          .collection('users')
          .doc(userId) 
          .collection('tasks')
          .doc(taskId)
          .update(updates);
      debugPrint("DEBUG: Tarefa com ID '$taskId' atualizada para o usuário '$userId'.");
    }
  }

  Future<void> deleteTask({required String taskId}) async {
    await _db
        .collection('artifacts')
        .doc('planify')
        .collection('users')
        .doc(userId) 
        .collection('tasks')
        .doc(taskId)
        .delete();
    debugPrint("DEBUG: Tarefa com ID '$taskId' deletada para o usuário '$userId'.");
  }

  
  Future<void> addProjectTask(
      String projectId, String taskTitle, String userId) async {
    
    
    
    debugPrint("DEBUG: Adicionando tarefa '$taskTitle' ao projeto '$projectId' para o usuário '$userId'.");
    
    
  }
}
